require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "Freeze" do
      context "Frozen" do
        handler = Handlers::Commands::Transactions.new

        processed_time = Controls::Time::Processed::Raw.example

        handler.clock.now = processed_time

        freeze = Controls::Commands::Freeze.example

        account_id = freeze.account_id or fail
        effective_time = freeze.time or fail

        handler.(freeze)

        writer = handler.write

        frozen = writer.one_message do |event|
          event.instance_of?(Messages::Events::Frozen)
        end

        test "Frozen Event is Written" do
          refute(frozen.nil?)
        end

        test "Written to the account stream" do
          written_to_stream = writer.written?(frozen) do |stream_name|
            stream_name == "account-#{account_id}"
          end

          assert(written_to_stream)
        end

        context "Attributes" do
          test "account_id" do
            assert(frozen.account_id == account_id)
          end

          test "time" do
            assert(frozen.time == effective_time)
          end

          test "processed_time" do
            processed_time_iso8601 = Clock::UTC.iso8601(processed_time)

            assert(frozen.processed_time == processed_time_iso8601)
          end

          test "sequence" do
            sequence = freeze.metadata.global_position

            assert(frozen.sequence == sequence)
          end
        end
      end
    end
  end
end
