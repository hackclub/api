module Hackbot
  module Interactions
    module Concerns
      module Followupable
        extend ActiveSupport::Concern

        included do
          before_handle :record_last_event_timestamp
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

        private

        def record_last_event_timestamp
          data['last_message_ts'] = event[:ts]
        end
      end
    end
  end
end
