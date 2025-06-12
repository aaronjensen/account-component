module AccountComponent
  module Messages
    module Commands
      class Freeze
        include Messaging::Message

        attribute :freeze_id, String
        attribute :account_id, String
        attribute :time, String
      end
    end
  end
end
