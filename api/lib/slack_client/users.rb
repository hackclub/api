module SlackClient
  module Users
    def self.info(user_id, access_token)
      SlackClient.rpc('users.info', access_token, user: user_id)
    end

    def self.list(access_token)
      SlackClient.rpc('users.list', access_token, presence: true)
    end
  end
end
