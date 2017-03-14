# Channel is an interaction that is limited to a single channel on Slack. Most
# interactions will inherit from this class.
module Hackbot
  module Interactions
    class Channel < Hackbot::Interaction
      def part_of_interaction?(event)
        event[:channel] == data['channel'] && super
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
