require_relative '../automated_init'

context "Projection" do
  context "Unfrozen" do
    account = Controls::Account::Frozen.example

    assert(account.frozen?)
    refute(account.frozen_time.nil?)

    unfrozen = Controls::Events::Unfrozen.example

    Projection.(account, unfrozen)

    test "Account is unfrozen" do
      refute(account.frozen?)
    end

    test "Frozen time is set to nil" do
      assert(account.frozen_time.nil?)
    end

    test "Sequence is set" do
      assert(account.sequence == unfrozen.sequence)
    end
  end
end
