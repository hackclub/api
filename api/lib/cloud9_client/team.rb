# frozen_string_literal: true

module Cloud9Client
  module Team
    def self.members(team_name)
      Cloud9Client.request(:get, "/user/org/#{team_name}/member")
    end

    def self.add_member(team_name, username)
      Cloud9Client.request(
        :post,
        "/user/org/#{team_name}/member",
        username: username,
        role: 'r',
        subscriptions: []
      )
    end

    def self.delete_member(team_name, username)
      Cloud9Client.request(:delete, "/user/org/#{team_name}/member/#{username}")
    end

    def self.invite_member(team_name, email)
      Cloud9Client.request(:post, "/user/org/#{team_name}/invite", email: email)
    end
  end
end
