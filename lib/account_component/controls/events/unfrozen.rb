module AccountComponent
  module Controls
    module Events
      module Unfrozen
        def self.example
          unfrozen = AccountComponent::Messages::Events::Unfrozen.build

          unfrozen.remove_freeze_id = ID.example
          unfrozen.account_id = Account.id
          unfrozen.time = Controls::Time::Effective.example
          unfrozen.processed_time = Controls::Time::Processed.example
          unfrozen.sequence = Sequence.example

          unfrozen
        end
      end
    end
  end
end
