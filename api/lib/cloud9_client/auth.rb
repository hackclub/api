# frozen_string_literal: true
module Cloud9Client
  module Auth
    class << self
      def login(username, password)
        authed_cookies = web_login(username, password)
        access_token = get_access_token(authed_cookies)

        { access_token: access_token }
      end

      private

      def web_login(username, password)
        resp = Cloud9Client.custom_request(
          :post,
          'https://c9.io/auth/login',
          {
            username: username,
            password: password
          }.to_json,
          {},
          'Origin' => 'https://c9.io',
          'Content-Type' => 'application/json'
        )

        resp.cookies
      end

      def get_access_token(authenticated_cookies)
        resp = Cloud9Client.custom_request(
          :get,
          'https://c9.io/api/nc/auth',
          nil,
          {
            'client_id' => 'profile_direct',
            'responseType' => 'direct',
            'login_hint' => nil,
            'immediate' => 1
          },
          {},
          authenticated_cookies
        )

        resp.body
      end
    end
  end
end
