# Resources
require "cloud9_client/team"

# Errors
require "common_client/errors/api_error"
require "common_client/errors/authentication_error"

module Cloud9Client
  @api_base = "https://api.c9.io"

  class << self
    attr_accessor :access_token, :api_base

    def api_url(url='')
      @api_base + url
    end
     def request(method, path, params={}, headers={})
       payload = nil

       unless @access_token
         raise AuthenticationError.new("No access token provided")
       end

       headers[:params] = { access_token:  @access_token }

       # Add browser headers, because we're just doing this from the browser,
       # right? ;-)
       headers['Pragma'] = 'no-cache'
       headers['Origin'] = 'https://c9.io'
       headers['Accept-Encoding'] = 'gzip, deflate, br'
       headers['Accept-Language'] = 'en-US,en;q=0.8'
       headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36'
       headers['Cache-Control'] = 'no-cache'
       headers['DNT'] = '1'

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
  end
end
