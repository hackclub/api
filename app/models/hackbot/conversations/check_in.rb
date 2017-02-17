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

      # rubocop:disable Metrics/LineLength, Metrics/MethodLength
      def start(event)
        leader_info = leader(event)
        first_name = leader_info.name.split(' ').first

        if first_check_in?
          msg_channel "Hey #{first_name}! I'm Hackbot, Hack Club's friendly "\
                      'robot helper.'
          msg_channel "I'll be reaching out to you every week, typically on "\
                      "Fridays, to check in and see how your club's doing. "\
                      "I'll be sharing everything with the team, so they'll "\
                      'be in the loop every step of the way '\
                      ':slightly_smiling_face:'
          msg_channel 'To start, did you have a club meeting this week?'
        else
          msg_channel "Hey #{first_name}! Did you have a club meeting this week?"
        end

        :wait_for_meeting_confirmation
      end
      # rubocop:enable Metrics/LineLength, Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def wait_for_meeting_confirmation(event)
        case event[:text]
        when /(yes|yeah|yup|mmhm|affirmative)/i
          msg_channel 'Okay, sweet! On which day was it? (say something '\
                      'like "monday" or "today")'

          :wait_for_day_of_week
        when /(no|nope|nah|negative)/i
          msg_channel 'Gotcha! Hope you have a great weekend.'

          :finish
        else
          msg_channel "I'm not very smart yet and had trouble understanding "\
                      'you :-/. Try saying something like "yes" or "no".'

          :wait_for_meeting_confirmation
        end
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def wait_for_day_of_week(event)
        meeting_date = Chronic.parse(event[:text], context: :past)

        unless meeting_date
          msg_channel "Man, I'm not very smart yet and had trouble "\
                      'understanding you. Try saying something simpler, like '\
                      '"tuesday" or "thursday".'

          return :wait_for_day_of_week
        end

        unless meeting_date > 7.days.ago && meeting_date < Date.tomorrow
          msg_channel "Hmm, #{meeting_date.to_date} didn't happen in the past "\
                      'week (though I may also be misunderstanding you). Can '\
                      'you try giving me the day of the week of your last '\
                      'meeting again?'

          return :wait_for_day_of_week
        end

        data['meeting_date'] = meeting_date

        msg_channel "How many people would you estimate came? (I'm not very "\
                    "smart, I'll need you to give me a single number, "\
                    'something like "25" – give your best estimate)'

        :wait_for_attendance
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
      def wait_for_attendance(event)
        unless integer?(event[:text])
          msg_channel "I didn't quite understand that. Can you try giving me "\
                      'a single number?'

          return :wait_for_attendance
        end

        count = event[:text].to_i

        if count < 0
          msg_channel "I'm going to need a positive number, silly. How many "\
                      'people came to the last meeting?'

          return :wait_for_attendance
        end

        data['attendance'] = count

        judgement = case count
                    when 0..9
                      'Nice!'
                    when 10..20
                      "#{count} is a number to be proud of!"
                    when 20..40
                      "Damn, #{count} is a huge number of people!"
                    when 40..100
                      "I have no words. #{count} people is incredible!"
                    else
                      "I'm speechless. That's incredible."
                    end

        msg_channel "#{judgement} Is there anything the Hack Club team can be "\
                    "helpful with? I'll send them anything you send my way "\
                    '(just make sure to include everything in a single '\
                    'message). If not, please just respond with "no".'

        :wait_for_notes
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength

      def wait_for_notes(event)
        data['notes'] = event[:text] unless event[:text] =~ /^(no|nope|nah)$/i

        ::CheckIn.create!(
          club: club(event),
          leader: leader(event),
          meeting_date: data['meeting_date'],
          attendance: data['attendance'],
          notes: data['notes']
        )

        msg_channel "Sweet, I'll let them know! Hope you have a hack-tastic "\
                    'weekend!'
      end

      private

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
        @u ||= user(event)
        @leader ||= Leader.find_by(slack_username: @u[:name])

        @leader
      end

      def user(event)
        user_id = event[:user]

        resp = SlackClient::Users.info(user_id, access_token)

        resp[:user]
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
