# frozen_string_literal: true

class AddHackbotTeamToSlackInviteStrategy < ActiveRecord::Migration[5.0]
  def change
    add_reference :slack_invites, :hackbot_team, foreign_key: true
    add_reference :slack_invite_strategies, :hackbot_team, foreign_key: true
  end
end
