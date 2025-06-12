module AccountComponent
  module Controls
    module Events
      module DepositRejected
        def self.example
          deposit_rejected = AccountComponent::Messages::Events::DepositRejected.build

          deposit_rejected.deposit_id = ID.example
          deposit_rejected.account_id = Account.id
          deposit_rejected.amount = Money.example
          deposit_rejected.time = Controls::Time::Effective.example

          deposit_rejected.sequence = Sequence.example

          deposit_rejected
        end
      end
    end
  end
end
