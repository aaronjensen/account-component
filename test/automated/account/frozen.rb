require_relative '../automated_init'

context "Account" do
  context "Has Frozen Time" do
    account = Controls::Account::Frozen.example

    test "Is frozen" do
      assert(account.frozen?)
    end
  end

  context "Does not Have Frozen Time" do
    account = Controls::Account.example

    test "Is not frozen" do
      refute(account.frozen?)
    end
  end
end
