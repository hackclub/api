module Hackbot
  module Interactions
    class FollowUp < Hackbot::Interactions::TextConversation
      include Concerns::Triggerable

      def should_start?
        false
      end

      def start
        msg_channel
      end
    end
  end
end
