module AccountComponent
  module Messages
    module Commands
      class RemoveFreeze
        include Messaging::Message

        attribute :remove_freeze_id, String
        attribute :account_id, String
        attribute :time, String
      end
    end
  end
end
