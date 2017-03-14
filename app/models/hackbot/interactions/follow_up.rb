module Hackbot
  module Interactions
    class FollowUp < TextConversation
      def handle(event)
        data['last_message_ts'] = event[:ts]

        super
      end

      def follow_up(messages, next_state, interval = 10.seconds)
        FollowUpIfNeededJob
          .set(wait: interval)
          .perform_later(
            id,
            next_state,
            data['last_message_ts'],
            interval.to_i,
            messages
          )
      end
    end
  end
end
