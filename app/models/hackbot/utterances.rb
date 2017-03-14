module Hackbot
  module Utterances
    # Returns a regex that matches @mentions or regular methods for the given
    # Slack team.
    def self.name(team)
      /(<@#{team.bot_user_id}>|#{team.bot_username})/
    end
  end
end
