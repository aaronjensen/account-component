require_relative '../../../test_init'

context "Handle Commands" do
  context "Freeze" do
    context "Not Reserved" do
      freeze_id = Identifier::UUID::Random.get

      freeze = Controls::Commands::Freeze.example(id: freeze_id)

      transaction_stream_name = "accountTransaction-#{freeze_id}"

      Messaging::Postgres::Write.(freeze, transaction_stream_name)

      Handlers::Commands.(freeze)

      event_data, * = MessageStore::Postgres::Get.(transaction_stream_name, position: 1, batch_size: 1)

      test "Freeze command is not written to transaction stream" do
        assert(event_data.nil?)
      end
    end
  end
end
