class SlackSignUpJob < ApplicationJob
  SLACK_THEME="&sidebar_theme=custom_theme&sidebar_theme_custom_values=%7B%22column_bg%22%3A%22%23ffffff%22%2C%22menu_bg%22%3A%22%23f9d5d9%22%2C%22active_item%22%3A%22%23e42d42%22%2C%22active_item_text%22%3A%22%23ffffff%22%2C%22hover_item%22%3A%22%23f9d5d9%22%2C%22text_color%22%3A%22%23e42d42%22%2C%22active_presence%22%3A%22%2328ce68%22%2C%22badge%22%3A%22%232d9ee4%22%7D".freeze

  DEFAULT_CHANNEL_ID="C756EH6VA".freeze

  def perform(invite_id)
    @invite = SlackInvite.find invite_id

    resp = sign_up
    @jar = resp.cookies
    @token = JSON.parse(resp)["api_token"]
    @invite.update({state: @invite.class::STATE_SIGNED_UP })

    set_user_pref('seen_welcome_2', 'true')
    set_user_pref('onboarding_cancelled', 'true')
    @invite.update({state: @invite.class::STATE_CONFIGURED_CLIENT })

    change_email
    @invite.update({state: @invite.class::STATE_EMAIL_CHANGED })
  end

  def sign_up
    RestClient.post(
      url_sign_up,
      {
        code: @invite.slack_invite_id,
        tz: 'America/Los_Angeles',
        password: @invite.password,
        emailok: 'false',
        real_name: @invite.full_name,
        display_name: @invite.username,
        last_tos_acknowledged: 'tos_oct2016',
        locale: 'en-US',

        multipart: true
      },
      cookies: { "b": sign_up_crumb }
    )
  end

  def set_user_pref(key, value)
    RestClient.post(
      url_user_prefs,
      {
        name: key,
        value: value,
        token: @token,

        multipart: true
      },
      cookies: @jar
    )
  end

  def change_email
    resp = RestClient.post(
      url_change_email,
      {
        change_email: 1,
        crumb: change_email_crumb,
        email_password: @invite.password,
        new_email: @invite.email,
      },
      cookies: @jar,
    )

    raise Exception("Expected a 302, did not get a 302.")

    resp
  rescue RestClient::Found=>e;
    # We want Slack to give us a 302 (NotFound)

    e.response
  end

  def go_to_channel(channel_id)
    RestClient.post(
      url_conversations_read,
      {
        channel: channel_id,
        ts: Time.now.to_f.round(6).to_s ,
        reason: 'viewed',
        token: @token,

        multipart: true
      },
      cookies: @jar
    )
  end

  def sign_up_crumb
    RestClient.get(@invite.slack_invite_url).cookies["b"]
  end

  def change_email_crumb
    resp = RestClient.get(url_change_email, cookies: @jar)

    Nokogiri::HTML(resp).at_css("input[name=\"crumb\"]")[:value]
  end

  def url_sign_up
    "https://#{team_subdomain}.slack.com/api/signup.createUser"
  end

  def url_user_prefs
    "https://#{team_subdomain}.slack.com/api/users.prefs.set"
  end

  def url_conversations_read
    "https://#{team_subdomain}.slack.com/api/conversations.mark"
  end

  def url_change_email
    "https://#{team_subdomain}.slack.com/account/settings".freeze
  end

  def team_subdomain
    @team_subdomain ||= SlackClient::Team.info(Rails.application.secrets.slack_admin_access_token)[:team][:domain]
  end
end
