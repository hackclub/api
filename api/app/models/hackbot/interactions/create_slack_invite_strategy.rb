module Hackbot
  module Interactions
    # rubocop:disable Metrics/ClassLength
    class CreateSlackInviteStrategy < Command
      DEFAULT_THEME = '&sidebar_theme=custom_theme&sidebar_theme_custom_values'\
        '={"column_bg":"#f6f6f6","menu_bg":"#eeeeee","active_item":"#fa3649",'\
        '"active_item_text":"#ffffff","hover_item":"#ffffff","text_color":'\
        '"#444444","active_presence":"#60d156","badge":"#fa3649"}'.freeze

      TRIGGER = /create-slack-invite-strategy/

      USAGE = 'create-slack-invite-strategy'.freeze
      DESCRIPTION = 'a handy command to create a slack invite strategy'.freeze
      def start
        unless leader
          msg_channel(copy('introduction.not_a_leader'))

          return
        end

        if leader.clubs.empty?
          msg_channel(copy('introduction.no_clubs'))

          return
        end

        msg_channel(copy('introduction.description'))

        msg_channel(
          text: copy('choose_name', name: default_name),
          attachments: [
            actions: [
              { text: 'Use default :fast_forward:', value: 'skip' }
            ]
          ]
        )

        :wait_for_name
      end

      def wait_for_name
        name = skipped? ? default_name : event[:text]

        if ::SlackInviteStrategy.exists?(name: name)
          msg_channel(copy('introduction.already_a_strategy'))

          return :finish
        end

        create_new_strategy(name)

        key = skipped? ? 'use_default' : 'use_custom'

        msg_channel(copy(key, key: 'name', val: name))

        msg_channel(
          text: copy('choose_club_name', club_name: default_club_name),
          attachments: [
            actions: [
              { text: 'Use default :fast_forward:', value: 'skip' }
            ]
          ]
        )

        :wait_for_club_name
      end

      def wait_for_club_name
        club_name = skipped? ? default_club_name : event[:text]
        strategy.update(club_name: club_name)

        key = skipped? ? 'use_default' : 'use_custom'

        msg_channel(copy(key, key: 'club name', val: club_name))

        msg_channel(
          text: copy('choose_greeting', greeting: default_greeting),
          attachments: [
            actions: [
              { text: 'Use default :fast_forward:', value: 'skip' }
            ]
          ]
        )

        :wait_for_greeting
      end

      def wait_for_greeting
        greeting = skipped? ? default_greeting : event[:text]
        strategy.update(greeting: greeting)

        key = skipped? ? 'use_default' : 'use_custom'

        msg_channel(copy(key, key: 'greeting', val: greeting))

        msg_channel(
          text: copy('should_add_user_group'),
          attachments: [
            actions: [
              { text: 'Yes!', value: 'yes' },
              { text: 'No.', value: 'no' }
            ]
          ]
        )

        :wait_for_should_add_user_group
      end

      def wait_for_should_add_user_group
        case action[:value]
        when 'yes'
          msg_channel(copy('add_user_group.add'))

          :wait_for_user_group
        when 'no'
          finish
        else
          :wait_for_should_add_user_group
        end
      end

      def wait_for_user_group
        m = msg.match(/<!subteam\^(\w*)\|.*\>/)

        if m
          strategy.user_groups << m[1]
          strategy.save

          msg_channel(copy('add_user_group.save'))

          finish
        else
          msg_channel(copy('add_user_group.error'))

          :wait_for_user_group
        end
      end

      def finish
        msg_channel(copy('finish', url: strategy.url))
        :finish
      end

      private

      def default_club_name
        l = Leader.find_by(slack_id: event[:user])

        l.clubs.first.name
      end

      def default_name
        default_club_name.downcase.gsub(/[^a-z0-9]/i, '')
      end

      def default_greeting
        'Hey! Welcome to the Slack :)'
      end

      def skipped?
        action.try(:[], :value) == 'skip'
      end

      def create_new_strategy(name)
        strat = SlackInviteStrategy.create(
          name: name,
          club_name: default_club_name,
          greeting: default_greeting,
          primary_color: 'E42D40',
          user_groups: [],
          theme: DEFAULT_THEME,
          team: team
        )

        data['strategy_id'] = strat.id

        strat
      end

      def strategy
        @strategy ||= SlackInviteStrategy.find data['strategy_id']
      end

      def leader
        Leader.find_by(slack_id: event[:user])
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
