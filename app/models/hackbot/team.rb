module Hackbot
  class Team < ApplicationRecord
    validates :team_id, :team_name, :bot_user_id, :bot_access_token, :bot_username,
              presence: true

    validates :team_id, :bot_user_id, :bot_access_token, uniqueness: true

    has_many :conversations,
             foreign_key: 'hackbot_team_id',
             class_name: ::Hackbot::Conversation
  end
end
