# frozen_string_literal: true
module Hackbot
  module Utterances
    # Returns a regex that matches @mentions or regular methods for the given
    # Slack team.
    def self.name(team)
      /(<@#{team.bot_user_id}>|#{team.bot_username})/i
    end

    def self.yes
      /^(yes|yea|yup|yep|ya|sure|ok|yeah|yah)/i
    end

    def self.no
      /^(no|nope|nah|negative)/i
    end
  end
end
