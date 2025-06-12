require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "RemoveFreeze" do
      context "Expected Version" do
        handler = Handlers::Commands::Transactions.new

        remove_freeze = Controls::Commands::RemoveFreeze.example

        account = Controls::Account::Frozen.example
        version = Controls::Version.example

        account.id = remove_freeze.account_id

        handler.store.add(account.id, account, version)

        handler.(remove_freeze)

        write = handler.write

        unfrozen = write.one_message do |event|
          event.instance_of?(Messages::Events::Unfrozen)
        end

        test "Is entity version" do
          written_to_stream = write.written?(unfrozen) do |_, expected_version|
            expected_version == version
          end

          assert(written_to_stream)
        end
      end
    end
  end
end
