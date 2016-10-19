# Resources
require "cloud9_client/auth"
require "cloud9_client/team"

# Errors
require "common_client/errors/api_error"
require "common_client/errors/authentication_error"

module Cloud9Client
  @api_base = "https://api.c9.io"

  class << self
    attr_accessor :username, :password, :api_base

    def api_url(url='')
      @api_base + url
    end

    def request(method, path, params={}, headers={})
      payload = nil

      headers[:params] = { access_token: access_token }
      headers.merge(default_headers)

      case method
      when :post
        headers['Content-Type'] = 'application/json'
        payload = params.to_json
      when :get
        headers[:params].merge params
      end

      headers['Accept'] = 'application/json'
      resp = RestClient::Request.execute(method: method, url: api_url(path),
                                         headers: headers, payload: payload)

      JSON.parse(resp, symbolize_names: true)
    end

    def custom_request(method, url, payload=nil, params={}, headers={},
                       cookies={}, use_default_headers=true)
      headers[:params] = params
      headers.merge(default_headers) if use_default_headers

      RestClient::Request.execute(method: method, url: url,
                                  headers: headers, payload: payload,
                                  cookies: cookies)
    end

    private

    def access_token
      if !@username or !@password
        raise AuthenticationError.new("Username and password must be set")
      end

      Rails.cache.fetch("cloud9_access_token", expires_in: 12.hours) do
        Cloud9Client::Auth.login(@username, @password)[:access_token]
      end
    end

    # Add browser headers, because we're just doing this from the browser,
    # right? ;-)
    def default_headers
      {
        "Pragma" => "no-cache",
        "Origin" => "https://c9.io",
        "Accept-Encoding" => "gzip, deflate, br",
        "Accept-Language" => "en-US,en;q=0.8",
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
        "Cache-Control" => "no-cache",
        "DNT" => "1"
      }
    end
  end
end
