require_relative '../../automated_init'

context "Commands" do
  context "Freeze" do
    freeze_id = Controls::ID.example
    account_id = Controls::Account.id
    effective_time = Controls::Time::Effective::Raw.example

    freeze = Commands::Freeze.new
    freeze.clock.now = effective_time

    freeze.(freeze_id: freeze_id, account_id: account_id)

    write = freeze.write

    freeze_message = write.one_message do |written|
      written.instance_of?(Messages::Commands::Freeze)
    end

    test "Freeze command is written" do
      refute(freeze_message.nil?)
    end

    test "Written to the account command stream" do
      written_to_stream = write.written?(freeze_message) do |stream_name|
        stream_name == "account:command-#{account_id}"
      end

      assert(written_to_stream)
    end

    context "Attributes" do
      test "freeze_id is assigned" do
        assert(freeze_message.freeze_id == freeze_id)
      end

      test "account_id" do
        assert(freeze_message.account_id == account_id)
      end

      test "time" do
        effective_time_iso8601 = Clock.iso8601(effective_time)

        assert(freeze_message.time == effective_time_iso8601)
      end
    end
  end
end
