require_relative '../../automated_init'

context "Commands" do
  context "RemoveFreeze" do
    remove_freeze_id = Controls::ID.example
    account_id = Controls::Account.id
    effective_time = Controls::Time::Effective::Raw.example

    remove_freeze = Commands::RemoveFreeze.new
    remove_freeze.clock.now = effective_time

    remove_freeze.(remove_freeze_id: remove_freeze_id, account_id: account_id)

    write = remove_freeze.write

    remove_freeze_message = write.one_message do |written|
      written.instance_of?(Messages::Commands::RemoveFreeze)
    end

    test "RemoveFreeze command is written" do
      refute(remove_freeze_message.nil?)
    end

    test "Written to the account command stream" do
      written_to_stream = write.written?(remove_freeze_message) do |stream_name|
        stream_name == "account:command-#{account_id}"
      end

      assert(written_to_stream)
    end

    context "Attributes" do
      test "remove_freeze_id is assigned" do
        assert(remove_freeze_message.remove_freeze_id == remove_freeze_id)
      end

      test "account_id" do
        assert(remove_freeze_message.account_id == account_id)
      end

      test "time" do
        effective_time_iso8601 = Clock.iso8601(effective_time)

        assert(remove_freeze_message.time == effective_time_iso8601)
      end
    end
  end
end
