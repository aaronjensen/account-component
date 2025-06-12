require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "RemoveFreeze" do
      context "Not Frozen" do
        handler = Handlers::Commands::Transactions.new

        remove_freeze = Controls::Commands::RemoveFreeze.example

        account = Controls::Account.example
        account.id = remove_freeze.account_id

        handler.store.add(account.id, account)

        handler.(remove_freeze)

        writer = handler.write

        test "Unfrozen Event is not Written" do
          unfrozen = writer.one_message do |event|
            event.instance_of?(Messages::Events::Unfrozen)
          end

          assert(unfrozen.nil?)
        end
      end
    end
  end
end
