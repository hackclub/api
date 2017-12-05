module Hackbot
  module Interactions
    class AddAdminUser < AdminCommand
      TRIGGER = /add-admin (?<token>.*)/

      USAGE = 'add-admin <access_token>'.freeze
      DESCRIPTION = 'add an admin access token for the current team (staff '\
        'only)'.freeze

      def start
        au = AdminUser.create(
          team: team.team_id,
          access_token: captured['token']
        )

        tag = au.save ? 'success' : 'failure'

        msg_channel(copy(tag))
      end
    end
  end
end
