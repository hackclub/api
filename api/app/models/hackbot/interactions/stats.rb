# frozen_string_literal: true
module Hackbot
  module Interactions
    class Stats < Command
      include Concerns::LeaderAssociable

      TRIGGER = /stats/

      USAGE = 'stats'
      DESCRIPTION = 'get some generated statistics on your club '\
                    '(leaders only)'

      def start
        if valid_stats?
          msg_channel copy('stats', school_name: stats.club_name,
                                    days_alive: stats.days_alive,
                                    total_meetings: stats.total_meetings_count,
                                    avg_attendance: stats.average_attendance)
        else
          handle_invalid_stats
        end
      end

      private

      def valid_stats?
        !(stats.leader.nil? || stats.check_ins.length <= 2)
      end

      def handle_invalid_stats
        selector = if stats.leader.nil?
                     'leader'
                   else
                     'check_ins'
                   end

        msg_channel copy("invalid.#{selector}")
      end

      def stats
        @stats ||= ::StatsService.new(leader)
      end

      def open_im(slack_id)
        SlackClient::Chat.open_im(slack_id, access_token)
      end
    end
  end
end
