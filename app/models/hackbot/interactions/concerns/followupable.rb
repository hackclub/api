module Hackbot
  module Interactions
    module Concerns
      module Followupable
        extend ActiveSupport::Concern

        include Concerns::LeaderAssociable

        included do
          before_handle :record_last_event_timestamp
        end

        def follow_up(messages, next_state, interval = 10.seconds)
          FollowUpIfNeededJob
            .set(wait: interval_in_timezone(interval))
            .perform_later(
              id,
              next_state,
              data['last_message_ts'],
              interval.to_i,
              messages
            )
        end

        private

        def interval_in_timezone(interval)
          tz_name = if leader.nil?
                      ''
                    else
                      leader.timezone.name
                    end

          FollowUpIfNeededJob.next_ping_interval(interval, tz_name)
        end

        def record_last_event_timestamp
          data['last_message_ts'] = event[:ts]
        end
      end
    end
  end
end
