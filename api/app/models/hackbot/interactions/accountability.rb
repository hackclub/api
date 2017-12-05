module Hackbot
  module Interactions
    class Accountability < Command
      include Concerns::Triggerable

      TRIGGER = /accountability/

      USAGE = 'accountability'.freeze
      DESCRIPTION = 'find out how far behind the team is in responding to '\
                    'applications'.freeze

      PIPELINE_KEY = Rails.application.secrets.streak_club_applications_pipeline_key # rubocop:disable Metrics/LineLength

      NEEDS_REVIEW_STAGE_KEY = '5001'.freeze
      ACCEPTED_STAGE_KEY = '5016'.freeze

      def start
        ua = unassigned_applications.count
        oua = old_unreviewed_applications.count
        aa = not_scheduled_applications.count

        notify_of('ua', ua)
        notify_of('oua', oua)
        notify_of('aa', aa)

        msg_channel copy('success') unless @incomplete_tasks
      end

      private

      def notify_of(name, count)
        if count == 1
          msg_channel copy("#{name}.single")
          @incomplete_tasks = true
        elsif count > 1
          msg_channel copy("#{name}.plural", count: count)
          @incomplete_tasks = true
        end
      end

      def not_scheduled_applications
        accepted_applications.select do |a|
          been_in_stage_for(a, 7.days.ago)
        end
      end

      def old_unreviewed_applications
        unreviewed_applications.select do |a|
          been_in_stage_for(a, 2.days.ago)
        end
      end

      def unassigned_applications
        unreviewed_applications
          .reject { |a| been_in_stage_for(a, 1.hour.ago) }
          .select do |a|
          assignees = a[:assigned_to_sharing_entries]

          assignees.find { |user| user[:email] == 'api@hackclub.com' } &&
            assignees.length == 1
        end
      end

      def unreviewed_applications
        applications.select { |a| a[:stage_key] == NEEDS_REVIEW_STAGE_KEY }
      end

      def accepted_applications
        applications.select { |a| a[:stage_key] == ACCEPTED_STAGE_KEY }
      end

      def applications
        @applications ||= StreakClient::Box.all_in_pipeline(PIPELINE_KEY)
      end

      def been_in_stage_for(a, t)
        ts = a[:last_stage_change_timestamp] / 1000
        in_stage_since = DateTime.strptime(ts.to_s, '%s')

        t > in_stage_since
      end
    end
  end
end
