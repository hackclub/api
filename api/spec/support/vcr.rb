# frozen_string_literal: true

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join('spec', 'vcr')
  c.hook_into :webmock
  c.configure_rspec_metadata!

  # Allow code coverage report to be sent to Code Climate
  c.ignore_hosts 'codeclimate.com'

  # Filter out everything in config/secrets.yml
  Rails.application.secrets.each do |k, v|
    c.filter_sensitive_data("ENV-#{k}") { v }
  end

  # Filter out Streak's API key
  c.filter_sensitive_data('<STREAK_API_KEY>') do
    Base64.strict_encode64(Rails.application.secrets.streak_api_key + ':')
  end

  # Filter out Cloud9 access tokens
  c.filter_sensitive_data('<CLOUD9_ACCESS_TOKEN>') do |interaction|
    url_params = Rack::Utils.parse_query(URI(interaction.request.uri).query)

    url_params['access_token']
  end

  # Don't match on the access_token URL parameter because we filter that out
  c.default_cassette_options[:match_requests_on] = [
    :method,
    VCR.request_matchers.uri_without_param(:access_token)
  ]

  # Filter out Cloud9 cookies
  c.filter_sensitive_data('<CLOUD9_LIVE_COOKIE>') do |interaction|
    cookies = server_cookies(interaction.response)
    next if cookies.blank?

    ck = cookies.find { |k| k.key? 'c9.live' }
    next unless ck

    ck['c9.live']
  end

  c.filter_sensitive_data('<CLOUD9_LIVE_PROXY_COOKIE>') do |interaction|
    cookies = server_cookies(interaction.response)
    next if cookies.blank?

    ck = cookies.find { |k| k.key? 'c9.live.proxy' }
    next unless ck

    ck['c9.live.proxy']
  end

  # This is kind of weird because it handles an edge case. For some requests
  # (like logging in), Cloud9 will return two c9.live.proxy cookies. This makes
  # sure we filter out the second cookie as well as the first.
  c.filter_sensitive_data('<CLOUD9_LIVE_PROXY_COOKIE_2>') do |interaction|
    cookies = server_cookies(interaction.response)
    next if cookies.blank?

    cks = cookies.select { |k| k.key? 'c9.live.proxy' }
    cks.last['c9.live.proxy'] if cks.length > 1
  end

  # Disable check on this method because it's throwing a false positive. See
  # https://github.com/bbatsov/rubocop/issues/3855.
  #
  def server_cookies(response)
    raw_cookies = response.headers['Set-Cookie']
    return if raw_cookies.blank?

    raw_cookies.map { |ck| parse_server_cookie(ck) }
  end
  # rubocop:enable Lint/NonLocalExitFromIterator

  def parse_server_cookie(raw_server_cookie)
    parsed_cookie = {}

    raw_server_cookie.split('; ').each do |pt|
      parts = pt.split('=', 2)

      parsed_cookie[parts.first] = parts.second
    end

    parsed_cookie
  end
end
