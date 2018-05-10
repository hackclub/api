# frozen_string_literal: true

module SlackClient
  module Channels
    def self.info(id, access_token)
      SlackClient.rpc('channels.info', access_token, channel: id)
    end
  end
end
