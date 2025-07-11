require_relative '../../../automated_init'

context "Handle Commands" do
  context "Transactions" do
    context "Freeze" do
      context "Ignored" do
        handler = Handlers::Commands::Transactions.new

        freeze = Controls::Commands::Freeze.example

        account = Controls::Account::Sequence.example

        sequence = account.sequence or fail

        freeze.metadata.global_position = sequence - 1

        handler.store.add(account.id, account)

        handler.(freeze)

        writer = handler.write

        test "Frozen Event is not Written" do
          frozen = writer.one_message do |event|
            event.instance_of?(Messages::Events::Frozen)
          end

          assert(frozen.nil?)
        end
      end
    end
  end
end
