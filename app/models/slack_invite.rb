# frozen_string_literal: true

class SlackInvite < ApplicationRecord
  SLACK_TEAM = Rails.application.secrets.default_slack_team_id
  ACCESS_TOKEN = Rails.application.secrets.slack_admin_access_token

  validates :email, presence: true, email: true
  validates :email, uniqueness: { case_sensitive: false }

  before_create :send_invite

  def send_invite
    resp = SlackClient::Team.invite_user(email, ACCESS_TOKEN)
    return if resp[:ok] == true

    errors.add(:base, "Slack API error: #{resp[:error]}")
    throw :abort
  end
end
