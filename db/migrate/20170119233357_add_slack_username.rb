class AddSlackUsername < ActiveRecord::Migration[5.0]
  def up
    Hackbot::Team.all.each do |team|
      info = ::SlackClient::Users.info(team.bot_user_id, team.bot_access_token)
      team.update(bot_username: info[:user][:name])
    end
  end

  def down
    Hackbot::Team.all.each do |team|
      team.update(bot_username: nil)
    end
  end
end
