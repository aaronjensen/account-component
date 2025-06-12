require_relative '../automated_init'

context "Projection" do
  context "Frozen" do
    account = Controls::Account.example

    assert(account.frozen_time.nil?)

    frozen = Controls::Events::Frozen.example

    Projection.(account, frozen)

    test "Frozen time is converted and copied" do
      frozen_time = Time.parse(frozen.time)

      assert(account.frozen_time == frozen_time)
    end

    test "Sequence is set" do
      assert(account.sequence == frozen.sequence)
    end
  end
end
