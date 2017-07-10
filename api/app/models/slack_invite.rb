class SlackInvite < ApplicationRecord
  ACCESS_TOKEN = Rails.application.secrets.slack_admin_access_token
  UNIQUENESS_MESSAGE = 'invite already sent for this email'.freeze

  before_create :invite
  validates :email, uniqueness: { message: UNIQUENESS_MESSAGE }

  def invite
    resp = SlackClient::Team.invite_user(email, ACCESS_TOKEN)

    return if resp[:ok]

    errors[:base] << "Slack API error: #{resp[:error]}"
    throw :abort
  end
end
