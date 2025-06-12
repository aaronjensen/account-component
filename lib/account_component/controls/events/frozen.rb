module AccountComponent
  module Controls
    module Events
      module Frozen
        def self.example
          frozen = AccountComponent::Messages::Events::Frozen.build

          frozen.freeze_id = ID.example
          frozen.account_id = Account.id
          frozen.time = Controls::Time::Effective.example
          frozen.processed_time = Controls::Time::Processed.example
          frozen.sequence = Sequence.example

          frozen
        end
      end
    end
  end
end
