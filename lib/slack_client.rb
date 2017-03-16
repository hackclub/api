require 'slack_client/channels'
require 'slack_client/chat'
require 'slack_client/groups'
require 'slack_client/im'
require 'slack_client/mpim'
require 'slack_client/oauth'
require 'slack_client/users'

module SlackClient
  @api_base = 'https://www.slack.com/api'

  class << self
    attr_accessor :api_base

    def rpc_url(method)
      @api_base + '/' + method
    end

    def rpc(method, access_token, args = {}, headers = {})
      args[:token] ||= access_token

      resp = RestClient::Request.execute(method: :post, url: rpc_url(method),
                                         headers: headers, payload: args)

      JSON.parse(resp.body, symbolize_names: true)
    end
  end
end
