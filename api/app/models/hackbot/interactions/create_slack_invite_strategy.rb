module Hackbot
  module Interactions
    class CreateSlackInviteStrategy < Command
      TRIGGER = /create-slack-invite-strategy (?<name>.*)/

      USAGE = 'create-slack-invite-strategy <strategy-name>'.freeze
      DESCRIPTION = 'a handy command to create a slack invite strategy'.freeze

      # rubocop:disable Metrics/MethodLength
      def start
        name = captured[:name]
        strat = SlackInviteStrategy.find_by(name: name)

        unless strat
          strat = SlackInviteStrategy.create(
            name: name,
            club_name: name,
            greeting: 'Welcome to the Slack!',
            primary_color: 'E42D40',
            channels: [],
            user_groups: [],
            team: team
          )
        end

        data['strategy_id'] = strat.id

        msg_channel(
          text: "What's the name of your club?",
          attachments: [
            actions: [
              { text: 'Skip :fast_forward:', value: 'skip' }
            ]
          ]
        )

        :wait_for_club_name
      end
      # rubocop:enable Metrics/MethodLength

      def wait_for_club_name
        strategy.update(club_name: event[:text]) unless skipped?

        msg_channel(
          text: 'How should your Slack members be greeted?',
          attachments: [
            actions: [
              { text: 'Skip :fast_forward:', value: 'skip' }
            ]
          ]
        )

        :wait_for_greeting
      end

      def wait_for_greeting
        strategy.update(greeting: event[:text]) unless skipped?

        msg_channel(
          text: 'What color should the theme of your form be?',
          attachments: [
            actions: [
              { text: 'Skip :fast_forward:', value: 'skip' }
            ]
          ]
        )

        :wait_for_color
      end

      def wait_for_color
        strategy.update(primary_color: event[:text]) unless skipped?

        msg_channel('Alright! Thanks for filling out this little form. You '\
                    'can see your Slack invite strategy live at '\
                    "#{strategy.url}")
      end

      private

      def skipped?
        action.try(:[], :value) == 'skip'
      end

      def strategy
        @strategy ||= SlackInviteStrategy.find data['strategy_id']
      end
    end
  end
end
