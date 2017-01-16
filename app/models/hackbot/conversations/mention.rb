module Hackbot
  module Conversations
    class Mention < Hackbot::Conversations::Channel
      def self.should_start?(event, team)
        event[:type] == 'message' &&
          (event[:text].include?(team[:bot_username]) ||
           event[:text].include?("<@#{team[:bot_username]}>"))
      end

      def start(_event)
        msg_channel 'Did someone mention me?'

        :wait_for_resp
      end

      def wait_for_resp(event)
        if event[:text] =~ /^(no|nope|nah|negative)$/i
          msg_channel 'Oh, I see... :slightly_frowning_face:'
        elsif event[:text] =~ /^(yes|yeah|yah|ya|yup)$/i
          msg_channel "Oh my! I'm so glad to hear... I was getting a little "\
                      'worried for a moment there.'
        end

        :finish
      end
    end
  end
end
