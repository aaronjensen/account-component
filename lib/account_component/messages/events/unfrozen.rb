module AccountComponent
  module Messages
    module Events
      class Unfrozen
        include Messaging::Message

        attribute :remove_freeze_id, String
        attribute :account_id, String
        attribute :time, String
        attribute :processed_time, String
        attribute :sequence, Integer
      end
    end
  end
end
