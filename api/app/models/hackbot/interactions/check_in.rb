# frozen_string_literal: true

# A few Rubocop cops are disabled in this file because it's pending a refactor.
# See https://github.com/hackclub/api/issues/25.
module Hackbot
  module Interactions
    class CheckIn < TextConversation
      include Concerns::LeaderAssociable
      include Concerns::Triggerable
      include Concerns::Followupable

      TASK_ASSIGNEE = Rails.application.secrets.default_streak_task_assignee
      SURVEY_WEEK = true

      def should_start?
        false
      end

      def start
        first_name = leader.name.split(' ').first
        flavor_text = copy('greeting.flavor_text')
        deadline = formatted_deadline leader
        key = 'greeting.' + (first_check_in? ? 'if_first_check_in' : 'default')
        key = 'greeting.restart' if @restart

        msg_channel copy(key,
                         first_name: first_name,
                         flavor_text: flavor_text,
                         deadline: deadline)
        SURVEY_WEEK ? initialize_survey_questions : initialize_weekly_questions
      end

      def wait_for_nps_score
        return :wait_for_nps_score unless msg

        unless integer?(msg)
          msg_channel copy('nps.invalid')
          return :wait_for_nps_score
        end

        nps_score = msg.to_i

        unless (0..10).cover?(nps_score)
          msg_channel copy('nps.out_of_bounds')
          return :wait_for_nps_score
        end

        data['nps_score'] = nps_score

        msg_channel copy('nps.score_confirmation', score: nps_score)
        msg_channel copy('nps.improve')

        default_follow_up 'wait_for_nps_improve'
        :wait_for_nps_improve
      end

      def wait_for_nps_improve
        return unless msg

        data['something_we_can_improve'] = msg

        msg_channel copy('nps.did_well')

        default_follow_up 'wait_for_nps_did_well'
        :wait_for_nps_did_well
      end

      def wait_for_nps_did_well
        return unless msg

        data['something_we_did_well'] = msg

        msg_channel copy('nps.completed')

        msg_channel(
          text: copy('events.organized.question'),
          attachments: [
            actions: [
              { text: 'Yes' },
              { text: 'No' }
            ]
          ]
        )

        default_follow_up 'wait_for_women_demographics'
        :wait_for_women_demographics
      end

      def wait_for_organized_events
        return :wait_for_organized_events unless action

        case action[:value]
        when Hackbot::Utterances.yes
          data['has_organized_event_this_semester'] = true
          send_action_result copy('events.organized.action_result.true')
        when Hackbot::Utterances.no
          data['has_organized_event_this_semester'] = false
          send_action_result copy('events.organized.action_result.false')
        else
          default_follow_up 'wait_for_organized_events'
          return :wait_for_organized_events
        end

        msg_channel(
          text: copy('events.attended.question'),
          attachments: [
            actions: [
              { text: 'Yes' },
              { text: 'No' }
            ]
          ]
        )

        default_follow_up 'wait_for_attended_events'
        :wait_for_attended_events
      end

      def wait_for_attended_events
        return :wait_for_attended_events unless action

        case action[:value]
        when Hackbot::Utterances.yes
          data['has_attended_event_this_semester'] = true
          send_action_result copy('events.attended.action_result.true')
        when Hackbot::Utterances.no
          data['has_attended_event_this_semester'] = false
          send_action_result copy('events.attended.action_result.false')
        else
          default_follow_up 'wait_for_attended_events'
          return :wait_for_attended_events
        end

        involvement = []
        involvement << 'attended' if data['has_attended_event_this_semester']
        involvement << 'organized' if data['has_organized_event_this_semester']
        unless involvement.empty?
          msg_channel copy('events.end_note',
                           count: involvement.count,
                           involvement: involvement.join(' and '))
        end

        msg_channel copy('demographics.introduction')
        msg_channel copy('demographics.women')

        default_follow_up 'wait_for_women_demographics'
        :wait_for_women_demographics
      end

      def wait_for_women_demographics
        return :wait_for_women_demographics unless msg
        msg_wo_percent_sign = msg.tr('%', '')

        unless integer?(msg_wo_percent_sign) && msg.include?('%')
          msg_channel copy('demographics.not_percentage')

          default_follow_up 'wait_for_women_demographics'
          return :wait_for_women_demographics
        end

        percent = msg_wo_percent_sign.to_i
        unless (0..100).cover?(percent)
          msg_channel copy('demographics.out_of_bounds', percent: percent)

          default_follow_up 'wait_for_women_demographics'
          return :wait_for_women_demographics
        end

        data['percent_women'] = percent
        msg_channel copy('demographics.confirm_recorded',
                         percent: percent,
                         metric: 'women')
        msg_channel copy('demographics.racial_minority')

        default_follow_up 'wait_for_racial_minority_demographics'
        :wait_for_racial_minority_demographics
      end

      def wait_for_racial_minority_demographics
        return :wait_for_racial_minority_demographics unless msg
        msg_wo_percent_sign = msg.tr('%', '')

        unless integer?(msg_wo_percent_sign) && msg.include?('%')
          msg_channel copy('demographics.not_percentage')

          default_follow_up 'wait_for_racial_minority_demographics'
          return :wait_for_racial_minority_demographics
        end

        percent = msg_wo_percent_sign.to_i
        unless (0..100).cover?(percent)
          msg_channel copy('demographics.out_of_bounds', percent: percent)

          default_follow_up 'wait_for_racial_minority_demographics'
          return :wait_for_racial_minority_demographics
        end

        data['percent_racial_minority'] = percent
        msg_channel copy('demographics.confirm_recorded',
                         percent: percent,
                         metric: 'not white or Asian')

        msg_channel copy('demographics.finished')

        initialize_weekly_questions
      end

      # rubocop:enable Metrics/LineLength
      def wait_for_is_dormant
        return :wait_for_is_dormant unless action

        case action[:value]
        when Hackbot::Utterances.yes
          send_action_result copy('is_dormant.positive.action_result')

          msg_channel copy('is_dormant.positive.text')
          data['is_dormant'] = true

          default_follow_up 'wait_for_resurrection_date'
          :wait_for_resurrection_date
        when Hackbot::Utterances.no
          @dormant = false

          send_action_result copy('is_dormant.negative.action_result')

          start
        else
          default_follow_up 'wait_for_is_dormant'
          :wait_for_is_dormant
        end
      end

      def wait_for_resurrection_date
        return :wait_for_is_dormant unless msg

        resurrection_date = Chronic.parse(msg, context: :future)

        if resurrection_date.nil?
          msg_channel copy('resurrection_date.unknown')

          default_follow_up 'wait_for_resurrection_date'
          return :wait_for_resurrection_date
        end

        data['resurrection_date'] = resurrection_date.to_s

        club.make_dormant(resurrection_date)

        prompt_for_submit

        default_follow_up 'wait_for_submit_confirmation'
        :wait_for_submit_confirmation
      end

      def wait_for_meeting_confirmation
        return :wait_for_meeting_confirmation unless action

        case action[:value]
        when 'previous_meeting_day'
          data['meeting_date'] = Chronic.parse(previous_meeting_day,
                                               context: :past)
          send_action_result(
            copy('meeting_confirmation.previous_meeting_day',
                 day: previous_meeting_day)
          )

          msg_channel copy('day_of_week.valid')

          default_follow_up 'wait_for_attendance'
          :wait_for_attendance
        when 'on_break'
          data['no_meeting_reason'] = 'School break'
          send_action_result copy('meeting_confirmation.on_break')

          prompt_for_submit

          default_follow_up 'wait_for_submit_confirmation'
          :wait_for_submit_confirmation
        when Hackbot::Utterances.yes
          send_action_result(
            copy('meeting_confirmation.had_meeting.action_result')
          )
          msg_channel copy('meeting_confirmation.had_meeting.ask_day_of_week')

          default_follow_up 'wait_for_day_of_week'
          :wait_for_day_of_week
        when Hackbot::Utterances.no
          send_action_result(
            copy('meeting_confirmation.no_meeting.action_result')
          )
          msg_channel(copy('meeting_confirmation.no_meeting.ask_why'))

          default_follow_up 'wait_for_no_meeting_reason'
          :wait_for_no_meeting_reason
        else
          default_follow_up 'wait_for_meeting_confirmation'
          :wait_for_meeting_confirmation
        end
      end

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

      def wait_for_meeting_in_the_future
        case msg
        when Hackbot::Utterances.yes
          msg_channel copy('meeting_in_the_future.positive')

          default_follow_up 'wait_for_help'
          :wait_for_help
        when Hackbot::Utterances.no
          msg_channel copy('meeting_in_the_future.negative')
          data['wants_to_be_dead'] = true

          prompt_for_submit

          default_follow_up 'wait_for_submit_confirmation'

          :wait_for_submit_confirmation
        else
          msg_channel copy('meeting_in_the_future.invalid')

          default_follow_up 'wait_for_meeting_in_the_future'
          :wait_for_meeting_in_the_future
        end
      end

      def wait_for_help
        return :wait_for_help unless msg

        # Don't record notes if the leader only responds with a negative
        # utterance such as "No"
        data['notes'] = msg unless Hackbot::Utterances.no.match(msg)

        prompt_for_submit

        default_follow_up 'wait_for_submit_confirmation'

        :wait_for_submit_confirmation
      end

      def wait_for_day_of_week
        return :wait_for_day_of_week unless msg

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

      def wait_for_attendance
        return :wait_for_attendance unless msg

        unless integer?(msg)
          msg_channel copy('attendance.invalid')

          default_follow_up 'wait_for_attendance'
          return :wait_for_attendance
        end

        count = msg.to_i

        if count.negative?
          msg_channel copy('attendance.not_realistic.negative')

          default_follow_up 'wait_for_attendance'
          return :wait_for_attendance
        end

        # Right now PG is storing attendance as an Integer, which means the max
        # size is 2147483647.
        if count > 2_147_483_647
          msg_channel copy('attendance.not_realistic.too_large')

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
                      copy('judgement.amazing')
                    end
        msg_channel copy('attendance.valid', judgement: judgement)
        msg_channel(
          text: copy('notes_confirmation.question'),
          attachments: [
            actions: [
              { text: 'Yes' },
              { text: 'No' }
            ]
          ]
        )

        default_follow_up 'wait_for_notes_confirmation'
        :wait_for_notes_confirmation
      end

      def wait_for_notes_confirmation
        return :wait_for_notes_confirmation unless action

        case action[:value]
        when Hackbot::Utterances.yes
          send_action_result copy('notes_confirmation.has_notes.action_result')
          msg_channel copy('notes_confirmation.has_notes.ask')

          :wait_for_notes
        when Hackbot::Utterances.no
          send_action_result copy('notes_confirmation.no_notes.action_result')

          prompt_for_submit

          default_follow_up 'wait_for_submit_confirmation'

          :wait_for_submit_confirmation
        end
      end

      def wait_for_notes
        return :wait_for_notes unless msg

        data['notes'] = msg

        prompt_for_submit

        default_follow_up 'wait_for_submit_confirmation'

        :wait_for_submit_confirmation
      end

      def wait_for_submit_confirmation
        return :wait_for_submit_confirmation unless action

        case action[:value].downcase
        when 'submit'
          send_action_result copy('submit_confirmation.submit.action_result')

          submit_check_in
          :finish
        when 'restart'
          send_action_result copy('submit_confirmation.restart.action_result')

          restart_check_in
        else

          default_follow_up 'wait_for_submit_confirmation'

          :wait_for_submit_confirmation
        end
      end

      def prompt_for_submit
        # This chunk is a hack to only display certain fields of the data hash
        # (ex. cut out "channel") and convert each field to a human readable
        # format (ex. changing meeting day from a timestamp to "Thursday").

        # This is totally jank and could be written many different ways. If you
        # have an idea of how to make this code more clear, please do rewrite
        # it.
        fields = data.map do |key, val|
          next if %w[channel last_message_ts club_id leader_id].include? key

          title = key.humanize
          value = val

          title = 'Wants to leave Hack Club' if key == 'wants_to_be_dead'
          title = 'Is going into dormant mode' if key == 'is_dormant'
          title = 'Reason for not meeting' if key == 'no_meeting_reason'
          if key == 'resurrection_date'
            title = "Resurrection date (we'll be in touch a few weeks "\
              'beforehand)'
          end

          value = 'Yes' if key == 'is_dormant'
          value = Date.parse(val).strftime('%A') if key == 'meeting_date'
          if key == 'resurrection_date'
            value = Date.parse(val).strftime('%Y-%m-%d')
          end

          { title: title, value: value.to_s }
        end
        fields.compact!

        msg_channel(
          text: copy('submit_confirmation.text'),
          attachments: [
            fields: fields,
            actions: [{ text: 'Restart' }, { text: 'Submit' }]
          ]
        )
      end

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

      def initialize_survey_questions
        msg_channel copy('nps.introduction')
        msg_channel copy('nps.score')

        default_follow_up 'wait_for_nps_score'
        :wait_for_nps_score
      end

      def initialize_weekly_questions
        actions = []

        if previous_meeting_day
          actions << {
            text: "Yes, on #{previous_meeting_day}",
            value: 'previous_meeting_day'
          }
        end

        actions << { text: 'Yes' }
        actions << {
          text: "No, we're on break",
          value: 'on_break'
        }
        actions << { text: 'No' }

        msg_channel(
          text: copy('meeting_confirmation.question'),
          attachments: [
            actions: actions
          ]
        )

        default_follow_up 'wait_for_meeting_confirmation'
        :wait_for_meeting_confirmation
      end

      def restart_check_in
        keys_to_save = %w[channel last_message_ts club_id leader_id]
        keys_to_delete = data.keys - keys_to_save
        keys_to_delete.each { |key| data.delete key }

        @restart = true

        start
      end

      def submit_check_in
        task_description = data['notes'] || data['no_meeting_reason']

        if task_description
          src = data['meeting_date'] ? 'check_in' : 'a failed meeting'
          create_task(leader, "Follow-up on notes from #{src}: "\
                              "#{task_description}")
        end

        send_submit_check_in_msg

        send_consecutive_check_in_msg

        return unless data['meeting_date']
        generate_check_in
        send_attendance_stats
      end

      def send_consecutive_check_in_msg
        count = consecutive_check_ins_count

        return unless count > 1

        judgement = if count > 6
                      copy('consecutive_check_in_streak.judgement.longer')
                    else
                      copy("consecutive_check_in_streak.judgement.#{count}")
                    end

        msg_channel copy('consecutive_check_in_streak.count',
                         count: count,
                         judgement: judgement)
      end

      def send_submit_check_in_msg
        suffix = if data['no_meeting_reason'] == 'School break'
                   copy('submit_check_in.on_break')
                 elsif !data['meeting_date'].nil?
                   copy('submit_check_in.dropbox')
                 end
        msg_channel copy('submit_check_in.thanks', suffix: suffix)
      end

      def consecutive_check_ins_count
        count = 0

        id = leader.id.to_s

        interactions = Hackbot::Interaction.where(type:
                                            'Hackbot::Interactions::CheckIn')
                                           .where("data->>'leader_id' = ?", id)
                                           .order('created_at DESC')

        interactions.each do |interaction|
          interaction.data['failed_to_complete'] ? break : count += 1
        end

        count
      end

      def formatted_deadline(lead)
        timezone = lead.timezone || Timezone.fetch('America/Los_Angeles')
        deadline_in_utc = Time.now.utc.next_week + 15.hours
        deadline_in_local_tz = timezone.utc_to_local(deadline_in_utc)
        day = deadline_in_local_tz.strftime('%A')

        case deadline_in_local_tz.hour
        when 0..6
          # Early morning on a day is written as the night of the previous day
          # For example, 2 AM Tuesday is "Monday night"
          day = deadline_in_local_tz.yesterday.strftime('%A')
          "#{day} night"
        when 7..12
          "#{day} morning"
        when 12
          "#{day} at noon"
        when 13..15
          "#{day} afternoon"
        when 16..23
          "#{day} night"
        end
      end

      def previous_meeting_day
        last_check_in = ::CheckIn.where(leader: leader)
                                 .order('meeting_date DESC')
                                 .first

        return nil if last_check_in.nil?

        Date::DAYNAMES[last_check_in.meeting_date.wday]
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
          stats.meeting_dates
        )

        file_to_channel('recent_attendance.png', Charts.as_file(graph))
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

      def should_ask_if_dead?
        Hackbot::Interactions::CheckIn
          .where("data->>'channel' = '#{data['channel']}'")
          .order('created_at DESC')
          .limit(3)
          .map { |c| c.data['attendance'].nil? }
          .reduce(:&)
      end

      def first_check_in?
        Hackbot::Interactions::CheckIn
          .where("data->>'channel' = ?", data['channel']).empty?
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
  end
end
