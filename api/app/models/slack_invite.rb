# frozen_string_literal: true

class SlackInvite < ApplicationRecord
  STATE_INVITED = 'invited'
  STATE_INVITE_RECEIVED = 'invite_received'
  STATE_SIGNED_UP = 'signed_up'
  STATE_CONFIGURED_CLIENT = 'configured_client'
  STATE_EMAIL_CHANGED = 'changed_email'

  TOKEN_LENGTH = 6

  after_initialize :defaults

  belongs_to :team,
             foreign_key: 'hackbot_team_id',
             class_name: 'Hackbot::Team'

  belongs_to :slack_invite_strategy

  validates :team, presence: true
  validates :username, uniqueness: true

  def dispatch
    resp = SlackClient::Team.invite_user(temp_email, admin_access_token)

    update(state: STATE_INVITED)

    return if resp[:ok]

    errors[:base] << "Slack API error: #{resp[:error]}"
    throw :abort
  end

  def temp_email
    "slack+#{token}@mail.hackclub.com"
  end

  def slack_invite_url
    "https://join.slack.com/t/hackclub/invite/#{slack_invite_id}"
  end

  private

  def defaults
    self.token ||= rand(36**TOKEN_LENGTH - 1).to_s(36)
  end

  def admin_access_token
    AdminUser.find_by(team: team.team_id).try(:access_token)
  end
end
