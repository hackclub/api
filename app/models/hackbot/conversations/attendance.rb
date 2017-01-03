module Hackbot
  module Conversations
    class Attendance < Hackbot::Conversations::Channel
      def self.should_start?(event)
        event[:type] == 'message' && event[:text] =~ /^attendance/
      end

      def start(_event)
        msg_channel "Another week, another time for attendance! Say 'go' when "\
                    "you're ready to begin."

        :wait_for_go
      end

      def wait_for_go(event)
        return :wait_for_go unless event[:type] == 'message'

        if event[:text] =~ /^(go|start|begin)$/i
          msg_channel "Sweet, let's do this! How many people came to your "\
                      'last meeting?'

          return :get_attendance
        end

        msg_channel "Huh, I didn't quite get that. Can you try again?"

        :wait_for_go
      end

      def get_attendance(event)
        msg_channel "Holy crap! #{event[:text]} is a huge number of people! "\
                    'Great work.'
      end
    end
  end
end
