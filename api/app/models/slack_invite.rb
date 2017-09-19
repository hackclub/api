class SlackInvite < ApplicationRecord
  ACCESS_TOKEN = Rails.application.secrets.slack_admin_access_token

  STATE_INVITED = 'invited'.freeze
  STATE_INVITE_RECEIVED = 'invite_received'.freeze
  STATE_SIGNED_UP = 'signed_up'.freeze
  STATE_CONFIGURED_CLIENT = 'configured_client'.freeze
  STATE_EMAIL_CHANGED = 'changed_email'.freeze

  TOKEN_LENGTH = 24

  after_initialize :defaults

  def dispatch
    resp = SlackClient::Team.invite_user(temp_email, ACCESS_TOKEN)

    self.state = STATE_INVITED

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
end
