# coding: utf-8

# A few Rubocop cops are disabled in this file because it's pending a refactor.
# See https://github.com/hackclub/api/issues/25.
module Hackbot
  module Interactions
    # rubocop:disable Metrics/ClassLength
    class CheckIn < TextConversation
      include Concerns::Followupable, Concerns::Triggerable,
              Concerns::LeaderAssociable

      TASK_ASSIGNEE = Rails.application.secrets.default_streak_task_assignee

      def should_start?
        false
      end

      def start
        first_name = leader.name.split(' ').first
        deadline = formatted_deadline leader
        key = (first_check_in? ? 'first_greeting' : 'greeting')

        msg_channel copy(key, first_name: first_name, deadline: deadline)

        default_follow_up 'wait_for_meeting_confirmation'

        :wait_for_meeting_confirmation
      end

      # rubocop:disable Metrics/MethodLength
      def wait_for_meeting_confirmation
        case msg
        when Hackbot::Utterances.yes
          msg_channel copy('meeting_confirmation.positive')

          default_follow_up 'wait_for_day_of_week'
          :wait_for_day_of_week
        when Hackbot::Utterances.no
          msg_channel copy('meeting_confirmation.negative')

          default_follow_up 'wait_for_no_meeting_reason'
          :wait_for_no_meeting_reason
        else
          msg_channel copy('meeting_confirmation.invalid')

          default_follow_up 'wait_for_meeting_confirmation'
          :wait_for_meeting_confirmation
        end
      end
      # rubocop:enable Metrics/MethodLength

      def wait_for_no_meeting_reason
        data['no_meeting_reason'] = msg

        if should_ask_if_dead?
          msg_channel copy('no_meeting_reason')

          default_follow_up 'wait_for_meeting_in_the_future'
          :wait_for_meeting_in_the_future
        else
          msg_channel copy('meeting_in_the_future.positive')

          default_follow_up 'wait_for_help'
          :wait_for_help
        end
      end

      # rubocop:disable Metrics/MethodLength
      def wait_for_meeting_in_the_future
        case msg
        when Hackbot::Utterances.yes
          msg_channel copy('meeting_in_the_future.positive')

          default_follow_up 'wait_for_help'
          :wait_for_help
        when Hackbot::Utterances.no
          msg_channel copy('meeting_in_the_future.negative')
          data['wants_to_be_dead'] = true

          :finish
        else
          msg_channel copy('meeting_in_the_future.invalid')

          default_follow_up 'wait_for_meeting_in_the_future'
          :wait_for_meeting_in_the_future
        end
      end
      # rubocop:enable Metrics/MethodLength

      def wait_for_help
        if should_record_notes?
          notes = record_notes
          create_task leader, 'Follow-up on notes from a failed '\
            "meeting: #{notes}"
        end

        msg_channel copy('help')
      end

      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def wait_for_day_of_week
        meeting_date = Chronic.parse(msg, context: :past)

        unless meeting_date
          msg_channel copy('day_of_week.unknown')

          default_follow_up 'wait_for_day_of_week'
          return :wait_for_day_of_week
        end

        unless meeting_date > 7.days.ago && meeting_date < Date.tomorrow
          msg_channel copy('day_of_week.invalid')

          default_follow_up 'wait_for_day_of_week'
          return :wait_for_day_of_week
        end

        data['meeting_date'] = meeting_date

        msg_channel copy('day_of_week.valid')

        default_follow_up 'wait_for_attendance'
        :wait_for_attendance
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

      # rubocop:disable Metrics/CyclomaticComplexity,
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def wait_for_attendance
        unless integer?(msg)
          msg_channel copy('attendance.invalid')

          default_follow_up 'wait_for_attendance'
          return :wait_for_attendance
        end

        count = msg.to_i

        if count < 0
          msg_channel copy('attendance.not_realistic')

          default_follow_up 'wait_for_attendance'
          return :wait_for_attendance
        end

        data['attendance'] = count

        judgement = case count
                    when 0..9
                      copy('judgement.ok', count: count)
                    when 10..20
                      copy('judgement.good', count: count)
                    when 20..40
                      copy('judgement.great', count: count)
                    when 40..100
                      copy('judgement.awesome', count: count)
                    else
                      copy('judgement.impossible')
                    end

        msg_channel copy('attendance.valid', judgement: judgement)

        default_follow_up 'wait_for_notes'
        :wait_for_notes
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def wait_for_notes
        if should_record_notes?
          notes = record_notes
          create_task leader, 'Follow-up on notes from check-in: '\
            "#{notes}"
        end

        generate_check_in

        if data['notes'].nil?
          msg_channel copy('notes.no_notes')
        else
          msg_channel copy('notes.had_notes')
        end

        send_attendance_stats
      end
      # rubocop:enable Metrics/MethodLength

      def generate_check_in
        ::CheckIn.create!(
          club: club,
          leader: leader,
          meeting_date: data['meeting_date'],
          attendance: data['attendance'],
          notes: data['notes']
        )
      end

      private

      def formatted_deadline(lead)
        timezone = lead.timezone || Timezone.fetch('America/Los_Angeles')
        date_format = '%A, %b %e at %l:%m %p'
        deadline_utc = DateTime.now.utc.next_week + 15.hours
        deadline_local = timezone.utc_to_local(deadline_utc)
        timezone_abbr = timezone.abbr(deadline_local)

        "#{deadline_local.strftime(date_format)} #{timezone_abbr}"
      end

      def default_follow_up(next_state)
        interval = 8.hours

        messages = [
          copy('follow_ups.first'),
          copy('follow_ups.second'),
          copy('follow_ups.third')
        ]

        follow_up(messages, next_state, interval)
      end

      def send_attendance_stats
        stats = statistics leader

        return if stats.total_meetings_count < 2

        graph = Charts.bar(
          stats.attendance,
          stats.labels
        )

        file_to_channel('attendance_this_week.png', Charts.as_file(graph))
      end

      def create_task(lead, text)
        StreakClient::Task.create(
          lead.streak_key,
          text,
          due_date: Time.zone.now.next_week(:monday),
          assignees: [TASK_ASSIGNEE]
        )
      end

      def statistics(leader)
        @stats ||= ::StatsService.new(leader)

        @stats
      end

      def should_record_notes?
        (msg =~ Hackbot::Utterances.no).nil?
      end

      def record_notes
        data['notes'] = msg
      end

      def should_ask_if_dead?
        Hackbot::Interactions::CheckIn
          .where("data->>'channel' = '#{data['channel']}'")
          .order('created_at DESC')
          .limit(3)
          .map { |c| c.data['attendance'].nil? }
          .reduce(:&)
      end

      def first_check_in?
        CheckIn.where("data->>'channel' = ?", data['channel']).empty?
      end

      def integer?(str)
        Integer(str) && true
      rescue ArgumentError
        false
      end

      def club
        leader.clubs.first
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
