require_relative '../../../test_init'

context "Handle Commands" do
  context "RemoveFreeze" do
    context "Not Reserved" do
      remove_freeze_id = Identifier::UUID::Random.get

      remove_freeze = Controls::Commands::RemoveFreeze.example(id: remove_freeze_id)

      transaction_stream_name = "accountTransaction-#{remove_freeze_id}"

      Messaging::Postgres::Write.(remove_freeze, transaction_stream_name)

      Handlers::Commands.(remove_freeze)

      event_data, * = MessageStore::Postgres::Get.(transaction_stream_name, position: 1, batch_size: 1)

      test "RemoveFreeze command is not written to transaction stream" do
        assert(event_data.nil?)
      end
    end
  end
end
