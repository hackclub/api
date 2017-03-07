module Hackbot
  module Conversations
    class Stats < Hackbot::Conversations::Channel
      def self.should_start?(event, team)
        event[:type] == 'message' && event[:text] =~ /.* stats$/ &&
          mentions_name?(event, team)
      end

      def start(event)
        stats = statistics(event)

        if stats.nil?
          msg_channel copy('invalid')

          return :finish
        end

        msg_channel copy('stats', school_name: stats.club_name,
                                  days_alive: stats.days_alive,
                                  total_meetings: stats.total_meetings_count,
                                  avg_attendance: stats.average_attendance)
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
