# frozen_string_literal: true

module SlackClient
  module Mpim
    def self.info(id, access_token)
      list(access_token)[:groups].find { |mpim| mpim[:id] == id }
    end

    def self.list(access_token)
      SlackClient.rpc('mpim.list', access_token)
    end
  end
end
