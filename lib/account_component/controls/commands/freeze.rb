module AccountComponent
  module Controls
    module Commands
      module Freeze
        def self.example(id: nil, account_id: nil)
          id ||= ID.example
          account_id ||= Account.id

          freeze = AccountComponent::Messages::Commands::Freeze.build

          freeze.freeze_id = id
          freeze.account_id = account_id
          freeze.time = Controls::Time::Effective.example

          freeze.metadata.global_position = Position.example

          freeze
        end
      end
    end
  end
end
