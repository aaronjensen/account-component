require_relative '../../automated_init'

context "Commands" do
  context "Freeze" do
    context "Optional Freeze ID" do
      account_id = Controls::Account.id

      context "Omitted" do
        freeze = Commands::Freeze.call(account_id: account_id)

        test "An ID is assigned" do
          refute(freeze.freeze_id.nil?)
        end
      end

      context "Supplied" do
        freeze_id = Controls::ID.example

        freeze = Commands::Freeze.call(account_id: account_id, freeze_id: freeze_id)

        test "ID is assigned to supplied ID" do
          assert(freeze.freeze_id == freeze_id)
        end
      end
    end
  end
end
