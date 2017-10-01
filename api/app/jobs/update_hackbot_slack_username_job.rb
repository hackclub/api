class UpdateHackbotSlackUsernameJob < ApplicationJob
  queue_as :default

  def perform(*)
    Hackbot::Team.find_each do |team|
      info = ::SlackClient::Users.info(team.bot_user_id, team.bot_access_token)

      # https://api.slack.com/methods/users.info
      if info[:error] == 'account_inactive'
        logger.info("Slack returned 'account_inactive' in team " \
                    "'#{team.team_name}'")
      else
        team.update(bot_username: info[:user][:profile][:display_name)
      end
    end
  end
end
