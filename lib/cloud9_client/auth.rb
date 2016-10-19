module Cloud9Client
  module Auth
    def self.login(username, password)
      login_resp = Cloud9Client.custom_request(
        :post,
        "https://c9.io/auth/login",
        {
          username: username,
          password: password
        }.to_json,
        {},
        {
          'Origin' => 'https://c9.io',
          'Content-Type' => 'application/json'
        }
      )

      token_resp = Cloud9Client.custom_request(
        :get,
        "https://c9.io/api/nc/auth",
        nil,
        {
          "client_id" => "profile_direct",
          "responseType" => "direct",
          "login_hint" => nil,
          "immediate" => 1
        },
        {},
        login_resp.cookies
      )

      { access_token: token_resp.body }
    end
  end
end
