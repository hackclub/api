# frozen_string_literal: true

module SlackClient
  module Users
    def self.info(user_id, access_token)
      SlackClient.rpc('users.info', access_token, user: user_id)
    end

    def self.list(access_token)
      SlackClient.rpc('users.list', access_token, presence: true)
    end

    def self.identity(access_token)
      SlackClient.rpc('users.identity', access_token)
    end
  end
end
