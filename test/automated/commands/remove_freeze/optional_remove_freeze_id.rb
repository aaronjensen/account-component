require_relative '../../automated_init'

context "Commands" do
  context "RemoveFreeze" do
    context "Optional RemoveFreeze ID" do
      account_id = Controls::Account.id

      context "Omitted" do
        remove_freeze = Commands::RemoveFreeze.call(account_id: account_id)

        test "An ID is assigned" do
          refute(remove_freeze.remove_freeze_id.nil?)
        end
      end

      context "Supplied" do
        remove_freeze_id = Controls::ID.example

        remove_freeze = Commands::RemoveFreeze.call(account_id: account_id, remove_freeze_id: remove_freeze_id)

        test "ID is assigned to supplied ID" do
          assert(remove_freeze.remove_freeze_id == remove_freeze_id)
        end
      end
    end
  end
end
