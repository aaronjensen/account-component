module AccountComponent
  module Controls
    module Commands
      module RemoveFreeze
        def self.example(id: nil, account_id: nil)
          id ||= ID.example
          account_id ||= Account.id

          remove_freeze = AccountComponent::Messages::Commands::RemoveFreeze.build

          remove_freeze.remove_freeze_id = id
          remove_freeze.account_id = account_id
          remove_freeze.time = Controls::Time::Effective.example

          remove_freeze.metadata.global_position = Position.example

          remove_freeze
        end
      end
    end
  end
end
