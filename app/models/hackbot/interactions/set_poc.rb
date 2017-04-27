module Hackbot
  module Interactions
    class SetPoc < AdminCommand
      TRIGGER = /set-poc ?(?<streak_key>.+)/

      USAGE = 'set-poc <leader_streak_key>'.freeze
      DESCRIPTION = 'set the given leader as the point of contact for their '\
                    'club (staff only)'.freeze

      def start
        streak_key = captured[:streak_key]

        leader = Leader.find_by(streak_key: streak_key)
        return msg_channel copy('start.invalid') if leader.nil?

        data['leader_id'] = leader.id

        associate_clubs(leader.clubs, leader)
      end

      def wait_for_clubs_num
        club_ids = data['club_ids']

        if valid_club_index_input? club_ids
          handle_club_index_input club_ids

          :wait_for_letter_decision
        else
          msg_channel copy('clubs_num.invalid', num_of_clubs: club_ids.length)

          :wait_for_clubs_num
        end
      end

      def wait_for_letter_decision
        leader = Leader.find data['leader_id']
        name = pretty_leader_name leader

        case msg
        when Hackbot::Utterances.yes
          create_welcome_letter_box(leader).save!

          msg_channel copy('letter_decision.affirmative', leader_name: name)
        when Hackbot::Utterances.no
          msg_channel copy('letter_decision.negative', leader_name: name)
        else
          msg_channel copy('letter_decision.invalid')
          :wait_for_letter_decision
        end
      end

      private

      def valid_club_index_input?(club_ids)
        integer?(msg) && (1..club_ids.length).cover?(msg.to_i)
      end

      def handle_club_index_input(club_ids)
        # Subtract 1 because the array is 0 indexed
        i = msg.to_i - 1

        leader = Leader.find data['leader_id']
        club = Club.find club_ids[i]

        set_poc club, leader
      end

      def associate_clubs(clubs, leader)
        if clubs.empty?
          name = pretty_leader_name leader
          msg_channel copy('start.no_clubs', leader_name: name)

          :finish
        elsif clubs.length == 1
          associate_single_club clubs.first, leader
          :wait_for_letter_decision
        else
          associate_one_in_many_clubs clubs, leader
        end
      end

      def unset_from_any_poc(leader)
        Club
          .where(point_of_contact_id: leader.id)
          .update_all(point_of_contact_id: nil)
      end

      def set_poc(club, leader)
        # Make sure to unset other POC relations so the club leader is only POC
        # for one club.
        unset_from_any_poc leader

        club.point_of_contact = leader

        name = pretty_leader_name leader
        if club.save!
          msg_channel copy('set.success', leader_name: name,
                                          club_name: club.name)
        else
          msg_channel copy('set.failure', leader_name: name,
                                          club_name: club.name)
        end
      end

      def integer?(str)
        Integer(str) && true
      rescue ArgumentError
        false
      end

      def associate_single_club(club, leader)
        set_poc club, leader
      end

      # Disabling rubocop here because it's ruling that this method doesn't make
      # any sense.
      #
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def associate_one_in_many_clubs(clubs, leader)
        msg_channel copy('start.many_clubs.intro',
                         leader_name: pretty_leader_name(leader))

        clubs.each.with_index(1) do |c, i|
          key = leader.streak_key
          msg_channel copy('start.many_clubs.each', i: i, club_name: c.name,
                                                    streak_key: key)
        end

        msg_channel copy('start.many_clubs.outro')

        data['club_ids'] = clubs.map(&:id)

        :wait_for_clubs_num
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      def create_welcome_letter_box(leader)
        Letter.new(
          name: leader.name,
          # This is the type for club leaders
          letter_type: '9002',
          # This is the type for welcome letter + 3oz of stickers
          what_to_send: '9005',
          address: leader.address
        )
      end

      def pretty_leader_name(leader)
        name = leader.name
        name << " (#{leader.slack_username})" if leader.slack_username
        name
      end

      def get_last_arg(text)
        text.split(' ').last
      end
    end
  end
end
