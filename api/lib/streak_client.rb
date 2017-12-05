# Resources
require 'streak_client/box'
require 'streak_client/pipeline'
require 'streak_client/task'

# Errors
require 'common_client/errors/api_error'
require 'common_client/errors/authentication_error'

# API client to Streak
module StreakClient
  @api_base = 'https://www.streak.com/api'

  class << self
    attr_accessor :api_key, :api_base

    def api_url(url = '')
      @api_base + url
    end

    # rubocop:disable Metrics/MethodLength
    def request(method, path, params = {}, headers = {}, cache = false,
                json = true)
      payload = nil

      raise AuthenticationError, 'No API key provided' unless @api_key

      headers['Authorization'] = construct_http_auth_header(@api_key, '')

      params = transform_params(params)
      url = api_url(path)

      case method
      when :post
        if json
          headers['Content-Type'] = 'application/json'
          payload = params.to_json
        else
          payload = params
        end
      when :put
        headers[:params] = params
      when :get
        headers[:params] = params
      end

      run_with_retry { perform_request(method, url, headers, payload, cache) }
    end
    # rubocop:enable Metrics/MethodLength

    private

    # rubocop:disable Metrics/MethodLength
    def run_with_retry
      cooldown = 2
      result = nil

      # If the request fails retry again two minutes later, keep on doubling
      # cooldown until it succeeds or goes above 30 seconds.
      while result.nil?
        begin
          result = yield
        rescue RestClient::Exception => e
          cooldown *= 2

          raise e if cooldown > 30

          Rails.logger.info("Failed Streak API request because of error #{e}. "\
                            "Trying again in #{cooldown} seconds.")

          Raven.extra_context(cooldown: cooldown)

          sleep cooldown
        end
      end

      result
    end
    # rubocop:enable Metrics/MethodLength

    def perform_request(method, url, headers, payload, cache)
      req = SentryRequestClient.new(method: method, url: url,
                                    headers: headers, payload: payload)

      resp = if cache
               Rails.cache.fetch(req.uri.to_s, expires_in: 5.minutes) do
                 req.execute.to_s
               end
             else
               req.execute.to_s
             end

      parse(resp)
    end

    def construct_http_auth_header(username, password)
      "Basic #{Base64.strict_encode64(username + ':' + password)}"
    end

    def transform_params(params)
      params
        .clone
        .deep_transform_keys { |k| k.to_s.camelize(:lower) }
    end

    # rubocop:disable Metrics/MethodLength
    def parse(response)
      parsed = JSON.parse(response, symbolize_names: true)

      snake_case_transform = lambda do |hash|
        hash
          .deep_transform_keys(&:to_s)
          .deep_transform_keys(&:underscore)
          .deep_transform_keys(&:to_sym)
      end

      if parsed.class == Array
        parsed.map(&snake_case_transform)
      else
        snake_case_transform.call(parsed)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
