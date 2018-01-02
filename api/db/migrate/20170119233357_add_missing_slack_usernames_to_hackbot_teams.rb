# frozen_string_literal: true

class AddMissingSlackUsernamesToHackbotTeams < ActiveRecord::Migration[5.0]
  # This class is scoped to this migration so it can still run if we ever remove
  # our Hackbot::Team class in the future.
  #
  # I decided to create a temporary Active Record model instead of writing a
  # custom SQL statement here, because Rails has sane defaults when it comes to
  # iterating through every record in the database.
  class HackbotTeam < ApplicationRecord; end

  def up
    HackbotTeam.all.each do |team|
      info = ::SlackClient::Users.info(team.bot_user_id, team.bot_access_token)
      team.update(bot_username: info[:user][:name])
    end
  end

  def down
    HackbotTeam.all.each { |t| t.update(bot_username: nil) }
  end
end
