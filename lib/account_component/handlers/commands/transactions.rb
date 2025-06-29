module AccountComponent
  module Handlers
    class Commands
      class Transactions
        include Log::Dependency
        include Messaging::Handle
        include Messaging::StreamName
        include Messages::Commands
        include Messages::Events

        dependency :write, Messaging::Postgres::Write
        dependency :clock, Clock::UTC
        dependency :store, Store

        def configure
          Messaging::Postgres::Write.configure(self)
          Clock::UTC.configure(self)
          Store.configure(self)
        end

        category :account

        handle Deposit do |deposit|
          account_id = deposit.account_id

          account, version = store.fetch(account_id, include: :version)

          sequence = deposit.metadata.global_position

          if account.processed?(sequence)
            logger.info(tag: :ignored) { "Command ignored (Command: #{deposit.message_type}, Account ID: #{account_id}, Account Sequence: #{account.sequence}, Deposit Sequence: #{sequence})" }
            return
          end

          time = clock.iso8601

          stream_name = stream_name(account_id)

          if account.frozen?
            deposit_rejected = DepositRejected.follow(deposit)
            deposit_rejected.time = time
            deposit_rejected.sequence = sequence

            write.(deposit_rejected, stream_name, expected_version: version)

            return
          end

          deposited = Deposited.follow(deposit)
          deposited.processed_time = time
          deposited.sequence = sequence

          write.(deposited, stream_name, expected_version: version)
        end

        handle Withdraw do |withdraw|
          account_id = withdraw.account_id

          account, version = store.fetch(account_id, include: :version)

          sequence = withdraw.metadata.global_position

          if account.processed?(sequence)
            logger.info(tag: :ignored) { "Command ignored (Command: #{withdraw.message_type}, Account ID: #{account_id}, Account Sequence: #{account.sequence}, Withdrawal Sequence: #{sequence})" }
            return
          end

          time = clock.iso8601

          stream_name = stream_name(account_id)

          if account.frozen?
            withdrawal_rejected = WithdrawalRejected.follow(withdraw)
            withdrawal_rejected.time = time
            withdrawal_rejected.sequence = sequence

            write.(withdrawal_rejected, stream_name, expected_version: version)

            return
          end

          unless account.sufficient_funds?(withdraw.amount)
            withdrawal_rejected = WithdrawalRejected.follow(withdraw)
            withdrawal_rejected.time = time
            withdrawal_rejected.sequence = sequence

            write.(withdrawal_rejected, stream_name, expected_version: version)

            return
          end

          withdrawn = Withdrawn.follow(withdraw)
          withdrawn.processed_time = time
          withdrawn.sequence = sequence

          write.(withdrawn, stream_name, expected_version: version)
        end

        handle Freeze do |freeze|
          account_id = freeze.account_id

          account, version = store.fetch(account_id, include: :version)

          sequence = freeze.metadata.global_position

          if account.processed?(sequence)
            logger.info(tag: :ignored) { "Command ignored (Command: #{freeze.message_type}, Account ID: #{account_id}, Account Sequence: #{account.sequence}, Freeze Sequence: #{sequence})" }
            return
          end

          if account.frozen?
            logger.info(tag: :ignored) { "Command ignored (Command: #{freeze.message_type}, Account ID: #{account_id}) - Account already frozen" }
            return
          end

          time = clock.iso8601

          frozen = Frozen.follow(freeze)
          frozen.processed_time = time
          frozen.sequence = sequence

          stream_name = stream_name(account_id)

          write.(frozen, stream_name, expected_version: version)
        end

        handle RemoveFreeze do |remove_freeze|
          account_id = remove_freeze.account_id

          account, version = store.fetch(account_id, include: :version)

          sequence = remove_freeze.metadata.global_position

          if account.processed?(sequence)
            logger.info(tag: :ignored) { "Command ignored (Command: #{remove_freeze.message_type}, Account ID: #{account_id}, Account Sequence: #{account.sequence}, RemoveFreeze Sequence: #{sequence})" }
            return
          end

          unless account.frozen?
            logger.info(tag: :ignored) { "Command ignored (Command: #{remove_freeze.message_type}, Account ID: #{account_id}) - Account not frozen" }
            return
          end

          time = clock.iso8601

          unfrozen = Unfrozen.follow(remove_freeze)
          unfrozen.processed_time = time
          unfrozen.sequence = sequence

          stream_name = stream_name(account_id)

          write.(unfrozen, stream_name, expected_version: version)
        end
      end
    end
  end
end
