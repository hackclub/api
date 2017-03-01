module Hackbot
  module Conversations
    class Stats < Hackbot::Conversations::Channel
      def self.should_start?(event, _team)
        event[:type] == 'message' &&
          event[:text] =~ /.* stats$/
      end

      def start(event)
        stats = statistics(event)

        if stats.nil?
          msg_channel "You don't seem to be a club leader!"

          return :finish
        end

        msg_channel '```'\
                    "These are stats for your club at #{stats.club_name}!\n"\
                    "In the #{stats.days_alive} days you've been checking in "\
                    "with me you've had #{stats.total_meetings_count} "\
                    "meetings.\n"\
                    "On average, you have #{stats.total_average_attendance} "\
                    'people attend your meetings.'\
                    '```'
      end

      private

      def statistics(event)
        lead = leader event

        return nil if lead.nil?

        ::StatsService.new(lead)
      end

      def leader(event)
        slack_user = SlackClient::Users.info(event[:user], access_token)[:user]

        Leader.find_by(slack_username: slack_user[:name])
      end

      def open_im(slack_id)
        SlackClient::Chat.open_im(slack_id, access_token)
      end
    end
  end
end
