# frozen_string_literal: true
module SlackClient
  module Groups
    def self.info(channel_id, access_token)
      SlackClient.rpc('groups.info', access_token, channel: channel_id)
    end
  end
end
