require_relative '../automated_init'

context "Projection" do
  context "Deposit Rejected" do
    account = Controls::Account::Balance.example

    deposit_rejected = Controls::Events::DepositRejected.example

    sequence = deposit_rejected.sequence or fail

    Projection.(account, deposit_rejected)

    test "Sequence is set" do
      assert(account.sequence == sequence)
    end
  end
end
