module AccountComponent
  module Commands
    class Freeze
      include Command

      def self.configure(receiver, attr_name: nil)
        attr_name ||= :freeze
        instance = build
        receiver.public_send("#{attr_name}=", instance)
      end

      def self.call(account_id:, freeze_id: nil, previous_message: nil)
        freeze_id ||= Identifier::UUID::Random.get
        instance = self.build
        instance.(freeze_id: freeze_id, account_id: account_id, previous_message: previous_message)
      end

      def call(freeze_id:, account_id:, previous_message: nil)
        freeze = self.class.build_message(Messages::Commands::Freeze, previous_message)

        freeze.freeze_id = freeze_id
        freeze.account_id = account_id
        freeze.time = clock.iso8601

        stream_name = command_stream_name(account_id)

        write.(freeze, stream_name)

        freeze
      end
    end
  end
end
