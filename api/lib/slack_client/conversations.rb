# frozen_string_literal: true
module SlackClient
  module Conversations
    def self.members(id, access_token)
      SlackClient.rpc('conversations.members', access_token, channel: id)
    end
  end
end
