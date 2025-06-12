require_relative '../../automated_init'

context "Handle Commands" do
  context "Freeze" do
    context "Reserved" do
      handler = Handlers::Commands.new

      freeze = Controls::Commands::Freeze.example

      freeze_id = freeze.freeze_id or fail

      handler.(freeze)

      writer = handler.write

      freeze_command = writer.one_message do |written|
        written.instance_of?(Messages::Commands::Freeze)
      end

      test "Freeze command is written to transaction stream" do
        refute(freeze_command.nil?)
      end

      test "Written to the freeze transaction stream" do
        written_to_stream = writer.written?(freeze_command) do |stream_name|
          stream_name == "accountTransaction-#{freeze_id}"
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "freeze_id" do
          assert(freeze_command.freeze_id == freeze_id)
        end

        test "account_id" do
          assert(freeze_command.account_id == freeze.account_id)
        end

        test "time" do
          assert(freeze_command.time == freeze.time)
        end
      end
    end
  end
end
