require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "Freeze" do
      context "Expected Version" do
        handler = Handlers::Commands::Transactions.new

        freeze = Controls::Commands::Freeze.example

        account = Controls::Account.example
        version = Controls::Version.example

        account.id = freeze.account_id

        handler.store.add(account.id, account, version)

        handler.(freeze)

        write = handler.write

        frozen = write.one_message do |event|
          event.instance_of?(Messages::Events::Frozen)
        end

        test "Is entity version" do
          written_to_stream = write.written?(frozen) do |_, expected_version|
            expected_version == version
          end

          assert(written_to_stream)
        end
      end
    end
  end
end
