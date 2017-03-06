# coding: utf-8

# A few Rubocop cops are disabled in this file because it's pending a refactor.
# See https://github.com/hackclub/api/issues/25.
module Hackbot
  module Conversations
    # rubocop:disable Metrics/ClassLength
    class CheckIn < Hackbot::Conversations::Channel
      def self.should_start?(event, _team)
        event[:text] == 'check in'
      end

      def start(event)
        leader_info = leader(event)
        first_name = leader_info.name.split(' ').first

        if first_check_in?
          msg_channel copy('first_greeting', first_name: first_name)
        else
          msg_channel copy('greeting', first_name: first_name)
        end

        :wait_for_meeting_confirmation
      end

      # rubocop:disable Metrics/MethodLength
      def wait_for_meeting_confirmation(event)
        case event[:text]
        when /(yes|yeah|yup|mmhm|affirmative)/i
          msg_channel copy('meeting_confirmation.positive')

          :wait_for_day_of_week
        when /(no|nope|nah|negative)/i
          msg_channel copy('meeting_confirmation.negative')

          :wait_for_no_meeting_reason
        else
          msg_channel copy('meeting_confirmation.invalid')

          :wait_for_meeting_confirmation
        end
      end
      # rubocop:enable Metrics/MethodLength

      def wait_for_no_meeting_reason(event)
        record_notes event if should_record_notes? event

        msg_channel copy('no_meeting_reason')
      end

      # rubocop:disable Metrics/MethodLength
      def wait_for_day_of_week(event)
        meeting_date = Chronic.parse(event[:text], context: :past)

        unless meeting_date
          msg_channel copy('day_of_week.unknown')

          return :wait_for_day_of_week
        end

        unless meeting_date > 7.days.ago && meeting_date < Date.tomorrow
          msg_channel copy('day_of_week.invalid')

          return :wait_for_day_of_week
        end

        data['meeting_date'] = meeting_date

        msg_channel copy('day_of_week.valid')

        :wait_for_attendance
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/CyclomaticComplexity,
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def wait_for_attendance(event)
        unless integer?(event[:text])
          msg_channel copy('attendance.invalid')

          return :wait_for_attendance
        end

        count = event[:text].to_i

        if count < 0
          msg_channel copy('attendance.not_realistic')

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

        :wait_for_notes
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def wait_for_notes(event)
        record_notes event if should_record_notes? event

        ::CheckIn.create!(
          club: club(event),
          leader: leader(event),
          meeting_date: data['meeting_date'],
          attendance: data['attendance'],
          notes: data['notes']
        )

        if data['notes'].nil?
          msg_channel copy('notes.no_notes')
        else
          msg_channel copy('notes.had_notes')
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      private

      def should_record_notes?(event)
        (event[:text] =~ /^(no|nope|nah)$/i).nil?
      end

      def record_notes(event)
        data['notes'] = event[:text]
      end

      def first_check_in?
        CheckIn.where("data->>'channel' = ?", data['channel']).empty?
      end

      def integer?(str)
        Integer(str) && true
      rescue ArgumentError
        false
      end

      def club(event)
        @leader ||= leader(event)

        @leader.clubs.first
      end

      def leader(event)
        @leader ||= Leader.find_by(slack_id: event[:user])

        @leader
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
