# frozen_string_literal: true
class RecordSlackStatsJob < ApplicationJob
  queue_as :default

  SLACK_TEAM_ID = 'T0266FRGM'
  SLACK_SUBDOMAIN = 'hackclub'
  SLACK_URL = "https://#{SLACK_SUBDOMAIN}.slack.com"
  SLACK_EMAIL = Rails.application.secrets.slack_admin_email
  SLACK_PASSWORD = Rails.application.secrets.slack_admin_password

  def perform
    stats = slack_stats
    SlackAnalyticLog.create(data: stats)
  end

  private

  def slack_auth_crumb
    # Slack's sign in form has a hidden input named "crumb" that must be
    # submitted to sign in

    page_html = RestClient.get(SLACK_URL).body

    crumb_selector = '#signin_form > input[name="crumb"]'
    crumb_value = Nokogiri::HTML(page_html).at_css(crumb_selector)[:value]
    crumb_value
  end
  # rubocop:disable Style/SymbolProc

  # SymbolProc is disabled because RestClient throws errors on 302 responses
  # without blocks
  def slack_auth_cookie
    payload = {
      signin:   '1',
      crumb:    slack_auth_crumb,
      email:    SLACK_EMAIL,
      password: SLACK_PASSWORD
    }

    user_agent = 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) ' \
                 'AppleWebKit/537.36 (KHTML, like Gecko) ' \
                 'Chrome/59.0.3071.115 Safari/537.36'

    cookies = RestClient::Request.execute(
      method: :post,
      url: SLACK_URL,
      payload: payload,
      user_agent: user_agent
    ) { |response| response.cookies }

    cookies
  end
  # rubocop:enable Style/SymbolProc

  def slack_api_token
    # Slack embeds an API token in the JavaScript of their stats page that is
    # required for their /api/team.stats.listUsers endpoint

    stats_html = RestClient::Request.execute(
      method: :get,
      url: "#{SLACK_URL}/admin/stats",
      cookies: @cookies
    ).body

    api_token_regex = /api_token: '(.*?)'/
    api_token = api_token_regex.match(stats_html).captures.first

    api_token
  end

  def slack_stats
    @cookies ||= slack_auth_cookie
    @api_token ||= slack_api_token

    payload = {
      date_range: '1d',
      token: @api_token,
      set_active: true
    }

    stats_json = RestClient::Request.execute(
      method: :post,
      payload: payload,
      url: "#{SLACK_URL}/api/team.stats.listUsers",
      cookies: @cookies
    ).body

    stats = JSON.parse(stats_json)

    stats
  end
end
