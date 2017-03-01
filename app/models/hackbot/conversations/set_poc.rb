module Hackbot
  module Conversations
    class SetPOC < Hackbot::Conversations::Channel
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

        handle_clubs(leader.clubs, leader)
      end

      def wait_for_clubs_num(event)
        club_ids = data['club_ids']

        unless integer? event[:text]
          msg_channel "Please choose a number between 0 and #{club_ids.length}!"

          return :wait_for_clubs_num
        end

        i = Integer event[:text]

        leader = Leader.find data['leader_id']
        club = Club.find club_ids[i]

        set_poc club, leader

        :finish
      end

      private

      def handle_clubs(clubs, leader)
        if clubs.empty?
          msg_channel "#{name} is not associated with any clubs :D"

          :finish
        elsif clubs.length == 1
          single_club clubs.first, leader
        else
          multiple_clubs clubs, leader
        end
      end

      def leader_from_event(event)
        streak_key = get_last_arg event[:text]

        Leader.find_by(streak_key: streak_key)
      end

      def set_poc(club, leader)
        club.point_of_contact = leader

        club.save!
      end

      def integer?(str)
        Integer(str) && true
      rescue ArgumentError
        false
      end

      def single_club(club, leader)
        name = pretty_leader_name leader

        msg_channel "#{name} has been associated with #{club.name}"

        set_poc club, leader

        :finish
      end

      def multiple_clubs(clubs, leader)
        name = pretty_leader_name leader

        msg_channel "#{name} is associated with the following clubs:"

        clubs.each_with_index do |c, i|
          msg_channel "#{i}. #{c.name} #{c.streak_key}"
        end

        msg_channel 'Please pick one and send the number associated with it'

        data['club_ids'] = clubs.map(&:id)
        data['leader_id'] = leader.id

        :wait_for_clubs_num
      end

      def pretty_leader_name(leader)
        "#{leader.name} (#{leader.slack_username})"
      end

      def get_last_arg(text)
        text.split(' ').last
      end
    end
  end
end
