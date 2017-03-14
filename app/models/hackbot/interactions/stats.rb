module Hackbot
  module Interactions
    class Stats < Command
      TRIGGER = /stats/

      def start(event)
        stats = statistics(event)

        if stats.nil?
          msg_channel copy('invalid')

          return :finish
        end

        msg_channel copy('stats', school_name: stats.club_name,
                                  days_alive: stats.days_alive,
                                  total_meetings: stats.total_meetings_count,
                                  avg_attendance: stats.average_attendance,
                                  compliment: copy('compliment'))
      end

      private

      def statistics(event)
        lead = leader event

        return nil if lead.nil?

        ::StatsService.new(lead)
      end

      def leader(event)
        pipeline_key = Rails.application.secrets.streak_leader_pipeline_key
        slack_id_field = :'1020'

        @leader_box ||= StreakClient::Box
                        .all_in_pipeline(pipeline_key)
                        .find { |b| b[:fields][slack_id_field] == event[:user] }

        @leader ||= Leader.find_by(streak_key: @leader_box[:key])
      end

      def open_im(slack_id)
        SlackClient::Chat.open_im(slack_id, access_token)
      end
    end
  end
end
