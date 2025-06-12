require_relative '../automated_init'

context "Account" do
  context "Unfreeze" do
    account = Controls::Account::Frozen.example

    assert(account.frozen?)

    account.unfreeze

    test "Frozen time is set to nil" do
      assert(account.frozen_time.nil?)
    end

    test "Is not frozen" do
      refute(account.frozen?)
    end
  end
end
