class SlackInvite < ApplicationRecord
  ACCESS_TOKEN = Rails.application.secrets.slack_admin_access_token

  STATE_INVITED = 'invited'
  STATE_INVITE_RECEIVED = 'invite_received'
  STATE_SIGNED_UP = 'signed_up'
  STATE_CONFIGURED_CLIENT = 'configured_client'
  STATE_EMAIL_CHANGED = 'changed_email'

  def send
    resp = SlackClient::Team.invite_user(temp_email, ACCESS_TOKEN)

    self.state = STATE_INVITED

    return if resp[:ok]

    errors[:base] << "Slack API error: #{resp[:error]}"
    throw :abort
  end

  def temp_email
    "slack+#{self.id}@mail.hackclub.com"
  end

  def slack_invite_url
    "https://join.slack.com/t/hackclub/invite/#{slack_invite_id}"
  end
end
