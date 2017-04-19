class Cloud9Invite < ApplicationRecord
  DEFAULT_TEAM_NAME = Rails.application.secrets.cloud9_team_name
  UNIQUENESS_MESSAGE = 'invite already sent for this email'.freeze

  validates :email, :team_name, presence: true
  validates :email, email: true
  validates :email, uniqueness: { message: UNIQUENESS_MESSAGE }

  after_initialize :set_defaults, unless: :persisted?
  before_create :send_invite

  def send_invite
    Cloud9Client::Team.invite_member(team_name, email)
  rescue RestClient::Conflict
    errors.add(:email, UNIQUENESS_MESSAGE)
    throw :abort
  end

  private

  def set_defaults
    self.team_name ||= DEFAULT_TEAM_NAME
  end
end
