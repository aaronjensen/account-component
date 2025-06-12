require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "Deposit" do
      context "Frozen" do
        handler = Handlers::Commands::Transactions.new

        processed_time = Controls::Time::Processed::Raw.example

        handler.clock.now = processed_time

        account = Controls::Account.example
        account.frozen_time = Time.parse(Controls::Time::Effective.example)

        handler.store.add(account.id, account)

        deposit = Controls::Commands::Deposit.example

        account_id = deposit.account_id or fail
        amount = deposit.amount or fail
        effective_time = deposit.time or fail
        global_position = deposit.metadata.global_position or fail

        handler.(deposit)

        writer = handler.write

        deposit_rejected = writer.one_message do |event|
          event.instance_of?(Messages::Events::DepositRejected)
        end

        test "Deposit Rejected Event is Written" do
          refute(deposit_rejected.nil?)
        end

        test "Written to the account stream" do
          written_to_stream = writer.written?(deposit_rejected) do |stream_name|
            stream_name == "account-#{account_id}"
          end

          assert(written_to_stream)
        end

        context "Attributes" do
          test "account_id" do
            assert(deposit_rejected.account_id == account_id)
          end

          test "amount" do
            assert(deposit_rejected.amount == amount)
          end

          test "time" do
            processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

            assert(deposit_rejected.time == processed_time_iso8601)
          end

          test "sequence" do
            assert(deposit_rejected.sequence == global_position)
          end
        end
      end
    end
  end
end
