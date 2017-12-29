# frozen_string_literal: true
class CreateHackbotTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :hackbot_teams do |t|
      t.text :team_id
      t.text :team_name

      t.text :bot_user_id
      t.text :bot_access_token

      t.timestamps
    end
  end
end
