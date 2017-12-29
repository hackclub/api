# frozen_string_literal: true
class AddSlackUserAndTeamIdToLeader < ActiveRecord::Migration[5.0]
  SLACK_TEAM_ID = Rails.application.secrets.default_slack_team_id

  def change
    add_column :leaders, :slack_id, :text
    add_column :leaders, :slack_team_id, :text

    reversible do |change|
      # Populate fields with slack usernames
      change.up do
        populate_slack_ids!
        populate_slack_team_ids!
      end
    end
  end

  private

  def populate_slack_ids!
    return if select_all('SELECT * FROM leaders').empty?

    leaders = select_all 'SELECT * FROM leaders '\
                         'WHERE slack_username IS NOT NULL AND '\
                         "slack_username != ''"

    all_users ||= slack_list_users access_token

    leaders.each do |leader|
      slack_user = all_users.find { |u| u[:name] == leader['slack_username'] }

      next if slack_user.nil?

      update "UPDATE leaders SET slack_id = '#{slack_user[:id]}' "\
             "WHERE slack_username = '#{leader['slack_username']}'"
    end
  end

  def access_token
    team = select_one 'SELECT * FROM hackbot_teams '\
                      "WHERE team_id = '#{SLACK_TEAM_ID}'"

    team['bot_access_token']
  end

  def populate_slack_team_ids!
    update "UPDATE leaders SET slack_team_id = '#{SLACK_TEAM_ID}'"
  end

  def slack_list_users(access_token)
    resp = RestClient::Request.execute(
      method: :post,
      url: 'https://www.slack.com/api/users.list',
      headers: {},
      payload: {
        token: access_token,
        presence: true
      }
    )

    JSON.parse(resp.body, symbolize_names: true)[:members]
  end
end
