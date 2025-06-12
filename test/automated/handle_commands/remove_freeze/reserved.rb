require_relative '../../automated_init'

context "Handle Commands" do
  context "RemoveFreeze" do
    context "Reserved" do
      handler = Handlers::Commands.new

      remove_freeze = Controls::Commands::RemoveFreeze.example

      remove_freeze_id = remove_freeze.remove_freeze_id or fail

      handler.(remove_freeze)

      writer = handler.write

      remove_freeze_command = writer.one_message do |written|
        written.instance_of?(Messages::Commands::RemoveFreeze)
      end

      test "RemoveFreeze command is written to transaction stream" do
        refute(remove_freeze_command.nil?)
      end

      test "Written to the remove freeze transaction stream" do
        written_to_stream = writer.written?(remove_freeze_command) do |stream_name|
          stream_name == "accountTransaction-#{remove_freeze_id}"
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "remove_freeze_id" do
          assert(remove_freeze_command.remove_freeze_id == remove_freeze_id)
        end

        test "account_id" do
          assert(remove_freeze_command.account_id == remove_freeze.account_id)
        end

        test "time" do
          assert(remove_freeze_command.time == remove_freeze.time)
        end
      end
    end
  end
end
