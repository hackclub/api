class SlackInviteStrategy < ApplicationRecord
  validates :name, uniqueness: true

  has_many :slack_invites

  belongs_to :team,
             foreign_key: 'hackbot_team_id',
             class_name: ::Hackbot::Team

  def url
    "https://hackclub.com/slack_invite/#{name}"
  end
end
