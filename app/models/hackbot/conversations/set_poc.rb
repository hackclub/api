module Hackbot
  module Conversations
    class SetPoc < Hackbot::Conversations::Channel
      def self.should_start?(event, _team)
        event[:type] == 'message' &&
          event[:text] =~ /^.* set-poc/
      end

      def start(event)
        leader = leader_from_event event

        if leader.nil?
          msg_channel "I can't find that Leader :-?"

          return :finish
        end

        associate_clubs(leader.clubs, leader)
      end

      def wait_for_clubs_num(event)
        club_ids = data['club_ids']

        if valid_club_index_input? event, club_ids
          handle_club_index_input event, club_ids
        else
          msg_channel "Please choose a number between 1 and #{club_ids.length}!"

          :wait_for_clubs_num
        end
      end

      private

      def valid_club_index_input?(event, club_ids)
        integer?(event[:text]) && (1..club_ids.length).cover?(event[:text].to_i)
      end

      def handle_club_index_input(event, club_ids)
        # Subtract 1 because the array is 0 indexed
        i = event[:text].to_i - 1

        leader = Leader.find data['leader_id']
        club = Club.find club_ids[i]

        set_poc club, leader

        :finish
      end

      def associate_clubs(clubs, leader)
        if clubs.empty?
          name = pretty_leader_name leader
          msg_channel "#{name} is not associated with any clubs :D"

          :finish
        elsif clubs.length == 1
          associate_single_club clubs.first, leader
        else
          associate_one_in_many_clubs clubs, leader
        end
      end

      def leader_from_event(event)
        streak_key = get_last_arg event[:text]

        Leader.find_by(streak_key: streak_key)
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
          msg_channel "#{name} has been associated with #{club.name}."
        else
          msg_channel "Unable to associate #{name} with #{club.name}."
        end
      end

      def integer?(str)
        Integer(str) && true
      rescue ArgumentError
        false
      end

      def associate_single_club(club, leader)
        set_poc club, leader

        :finish
      end

      def associate_one_in_many_clubs(clubs, leader)
        name = pretty_leader_name leader

        msg_channel "#{name} is associated with the following clubs:"

        clubs.each.with_index(1) do |c, i|
          msg_channel "#{i}. #{c.name} #{c.streak_key}"
        end

        msg_channel 'Please pick one and send the number associated with it'

        data['club_ids'] = clubs.map(&:id)
        data['leader_id'] = leader.id

        :wait_for_clubs_num
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
