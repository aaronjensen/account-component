module AccountComponent
  module Messages
    module Events
      class DepositRejected
        include Messaging::Message

        attribute :deposit_id, String
        attribute :account_id, String
        attribute :amount, Numeric
        attribute :time, String
        attribute :sequence, Integer
      end
    end
  end
end
