# Resources
require "streak_client/pipeline"
require "streak_client/box"

# Errors
require "streak_client/errors/streak_error"
require "streak_client/errors/authentication_error"

# API client to Streak
module StreakClient
  @api_base = "https://www.streak.com/api"

  class << self
    attr_accessor :api_key, :api_base
  end

  def self.api_url(url='')
    @api_base + url
  end

  def self.request(method, path, params={}, headers={})
    payload = nil

    unless @api_key
      raise AuthenticationError.new("No API key provided")
    end

    headers["Authorization"] = construct_http_auth_header(@api_key, "")

    case method
    when :post
      headers['Content-Type'] = 'application/json'
      payload = params.to_json
    when :get
      headers[:params] = params
    end

    resp = RestClient::Request.execute(method: method, url: api_url(path),
                                       headers: headers, payload: payload)

    parse(resp)
  end

  private

  def self.construct_http_auth_header(username, password)
    "Basic #{Base64.encode64(username + ':' + password)}"
  end

  def self.parse(response)
    parsed = JSON.parse(response, symbolize_names: true)

    snake_case_transform = ->(hash) {
      hash
        .deep_transform_keys(&:to_s)
        .deep_transform_keys(&:underscore)
        .deep_transform_keys(&:to_sym)
    }

    if parsed.class == Array
      parsed.map(&snake_case_transform)
    else
      snake_case_transform.(parsed)
    end
  end
end
