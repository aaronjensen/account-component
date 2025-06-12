require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "RemoveFreeze" do
      context "Ignored" do
        handler = Handlers::Commands::Transactions.new

        remove_freeze = Controls::Commands::RemoveFreeze.example

        account = Controls::Account::Sequence.example

        sequence = account.sequence or fail

        remove_freeze.metadata.global_position = sequence - 1

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
