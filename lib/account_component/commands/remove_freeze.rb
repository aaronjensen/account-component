module AccountComponent
  module Commands
    class RemoveFreeze
      include Command

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :remove_freeze
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.call(account_id:, remove_freeze_id: nil, previous_message: nil)
        remove_freeze_id ||= Identifier::UUID::Random.get
        instance = self.build
        instance.(remove_freeze_id: remove_freeze_id, account_id: account_id, previous_message: previous_message)
      end

      def call(remove_freeze_id:, account_id:, previous_message: nil)
        remove_freeze = self.class.build_message(Messages::Commands::RemoveFreeze, previous_message)

        remove_freeze.remove_freeze_id = remove_freeze_id
        remove_freeze.account_id = account_id
        remove_freeze.time = clock.iso8601

        stream_name = command_stream_name(account_id)

        write.(remove_freeze, stream_name)

        remove_freeze
      end
    end
  end
end
