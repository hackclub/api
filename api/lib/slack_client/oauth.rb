# frozen_string_literal: true
module SlackClient
  module Oauth
    def self.access(client_id, client_secret, code, redirect_uri = nil)
      SlackClient.rpc(
        'oauth.access',
        nil,
        client_id: client_id,
        client_secret: client_secret,
        code: code,
        redirect_uri: redirect_uri
      )
    end
  end
end
