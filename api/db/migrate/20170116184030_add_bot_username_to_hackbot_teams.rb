# frozen_string_literal: true
class AddBotUsernameToHackbotTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :hackbot_teams, :bot_username, :text
  end
end
