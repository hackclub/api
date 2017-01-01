class Hackbot::Team < ApplicationRecord
  validates_presence_of :team_id, :team_name, :bot_user_id, :bot_access_token
  validates_uniqueness_of :team_id, :bot_user_id, :bot_access_token

  has_many :conversations, foreign_key: 'hackbot_team_id', class_name: ::Hackbot::Conversation
end
