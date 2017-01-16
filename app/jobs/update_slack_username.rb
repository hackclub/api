class UpdateSlackUsername < ApplicationJob
  queue_as :default

  def perform(*)
    Hackbot::Team.find_each do |team|
      info = ::SlackClient::Users.info(team.bot_user_id, team.bot_access_token)
      team.update({ bot_username: info[:user][:name] })
    end
  end
end
