# TextConversation is an interaction that only consists of messages and is
# limited to a single channel on Slack.
module Hackbot
  module Interactions
    class TextConversation < Hackbot::Interaction
      def self.should_start?(event, team)
        event[:type] == 'message'
      end

      def part_of_interaction?(event)
        event[:type] == 'message' &&
          event[:channel] == data['channel'] &&
          super
      end

      def handle(event)
        data['channel'] = event[:channel]
        super
      end

      protected

      def msg_channel(text)
        send_msg(data['channel'], text)
      end

      def file_to_channel(filename, file)
        send_file(data['channel'], filename, file)
      end
    end
  end
end
