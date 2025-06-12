require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "RemoveFreeze" do
      context "Unfrozen" do
        handler = Handlers::Commands::Transactions.new

        processed_time = Controls::Time::Processed::Raw.example

        handler.clock.now = processed_time

        remove_freeze = Controls::Commands::RemoveFreeze.example

        account_id = remove_freeze.account_id or fail
        effective_time = remove_freeze.time or fail

        # Ensure account is frozen before unfreezing
        account = Controls::Account::Frozen.example
        account.id = account_id
        handler.store.add(account.id, account)

        handler.(remove_freeze)

        writer = handler.write

        unfrozen = writer.one_message do |event|
          event.instance_of?(Messages::Events::Unfrozen)
        end

        test "Unfrozen Event is Written" do
          refute(unfrozen.nil?)
        end

        test "Written to the account stream" do
          written_to_stream = writer.written?(unfrozen) do |stream_name|
            stream_name == "account-#{account_id}"
          end

          assert(written_to_stream)
        end

        context "Attributes" do
          test "account_id" do
            assert(unfrozen.account_id == account_id)
          end

          test "time" do
            assert(unfrozen.time == effective_time)
          end

          test "processed_time" do
            processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

            assert(unfrozen.processed_time == processed_time_iso8601)
          end

          test "sequence" do
            sequence = remove_freeze.metadata.global_position

            assert(unfrozen.sequence == sequence)
          end
        end
      end
    end
  end
end
