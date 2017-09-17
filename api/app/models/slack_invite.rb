class SlackInvite < ApplicationRecord
  ACCESS_TOKEN = "xoxs-243218758359-242269063989-242324771522-a1e1939aa4" # Rails.application.secrets.slack_admin_access_token

  def send
    resp = SlackClient::Team.invite_user(temp_email, ACCESS_TOKEN)

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
