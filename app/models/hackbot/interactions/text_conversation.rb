# TextConversation is an interaction that only consists of messages and is
# limited to a single channel on Slack.
module Hackbot
  module Interactions
    class TextConversation < Hackbot::Interaction
      include Concerns::Mirrorable

      def should_start?
        event[:type] == 'message'
      end

      def should_handle?
        (new_msg? || action) &&
          event[:channel] == data['channel'] &&
          super
      end

      def handle
        data['channel'] = event[:channel]
        super
      end

      protected

      def msg_channel(text)
        send_msg(data['channel'], text)
      end

      def attach_channel(*attachments)
        attach(data['channel'], *attachments)
      end

      def file_to_channel(filename, file)
        send_file(data['channel'], filename, file)
      end

      private

      # Returns whether the current event is a new message. This prevents
      # interactions from being triggered on message edits or other subtypes of
      # messages.
      def new_msg?
        msg && !event[:subtype]
      end
    end
  end
end
