module Hackbot
  module Interactions
    class Lookup < AdminCommand
      include ActionView::Helpers::DateHelper

      TRIGGER = /lookup <@(?<uid>.*)>/

      # Quick heads up that &lt; and &gt; are the HTML encodings for < and >,
      # respectively. Slack requires these characters be HTML encoded.
      USAGE = 'lookup &lt;@username&gt;'.freeze
      DESCRIPTION = 'look up a leader and their club from their Slack '\
                    'username (staff only)'.freeze

      def start
        data['uid_to_lookup'] = captured[:uid]

        if in_pm?
          lookup
        else
          msg_channel copy('confirm.msg')
          :confirm
        end
      end

      def confirm
        return :confirm unless action

        case action[:value]
        when Hackbot::Utterances.yes
          send_action_result(copy('confirm.results.proceed'))
          lookup
        when Hackbot::Utterances.no
          send_action_result(copy('confirm.results.cancel'))
        end
      end

      private

      def lookup
        uid = data['uid_to_lookup']

        leader = Leader.find_by(slack_id: uid)
        return not_found unless leader

        msg_channel construct_msg(leader)
      end

      def not_found
        msg_channel copy('not_found')
      end

      def construct_msg(leader)
        msg = {
          text: copy('resp_prefix'),
          attachments: [
            construct_leader_attachment(leader),
            *leader.clubs.map { |c| construct_club_attachment(c) }
          ]
        }

        insert_fallbacks!(msg)
      end

      def construct_leader_attachment(leader)
        copy(
          'leader_attachment',
          color: generate_color(leader.id),
          leader: leader,
          leader_icon_url: icon_for_leader(leader),
          slack: linked_slack(leader.slack_username),
          github: linked_profile(leader.github_username, 'https://github.com'),
          twitter:
            linked_profile(leader.twitter_username, 'https://twitter.com')
        )
      end

      def icon_for_leader(leader)
        info = SlackClient::Users.info(leader.slack_id, access_token)[:user]

        info[:profile][:image_72]
      end

      def linked_profile(username, url)
        return nil unless username.present? && url.present?

        "<#{url}/#{username}|#{username}>"
      end

      def construct_club_attachment(club)
        color = generate_color(club.id)
        stats = ClubStatsService.new(club)
        leaders = club.leaders.map { |l| linked_slack(l.slack_id) }
        poc = linked_slack(club.point_of_contact.slack_id) if
          club.point_of_contact.present?

        copy('club_attachment', color: color, club: club, stats: stats,
                                leaders: leaders, poc: poc)
      end

      def generate_color(seed)
        Digest::MD5.hexdigest(seed.to_s)[0, 6]
      end

      def linked_slack(username_or_id)
        return nil unless username_or_id.present?

        "<@#{username_or_id}>"
      end

      # Given a message to be sent to Slack, set N/A as the value for any
      # attachment fields that aren't present.
      def insert_fallbacks!(msg)
        msg[:attachments].each do |attachment|
          next unless attachment[:fields]

          attachment[:fields].each do |field|
            field[:value] = 'N/A' unless field[:value].present?
          end
        end

        msg
      end
    end
  end
end
