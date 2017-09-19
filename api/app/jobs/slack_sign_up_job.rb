class SlackSignUpJob < ApplicationJob
  DEFAULT_CHANNEL_ID = 'C74HZS5A5'.freeze

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def perform(invite_id)
    @invite = SlackInvite.find invite_id

    resp = sign_up
    @jar = resp.cookies
    @token = JSON.parse(resp)['api_token']
    @invite.update(state: @invite.class::STATE_SIGNED_UP)

    set_user_pref('seen_welcome_2', 'true')
    set_user_pref('onboarding_cancelled', 'true')
    @invite.update(state: @invite.class::STATE_CONFIGURED_CLIENT)

    change_email
    @invite.update(state: @invite.class::STATE_EMAIL_CHANGED)

    @invite.update(password: '')
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
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
      cookies: { 'b' => sign_up_crumb }
    )
  end
  # rubocop:enable Metrics/MethodLength

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

  # rubocop:disable Metrics/MethodLength
  def change_email
    RestClient.post(
      url_change_email,
      {
        change_email: 1,
        crumb: change_email_crumb,
        email_password: @invite.password,
        new_email: @invite.email
      },
      cookies: @jar
    )

    raise Exception('Expected a 302, did not get a 302.')
  rescue RestClient::Found => e
    # We want Slack to give us a 302 (NotFound)

    e.response
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def go_to_channel(channel_id)
    RestClient.post(
      url_conversations_read,
      {
        channel: channel_id,
        ts: Time.now.to_f.round(6).to_s,
        reason: 'viewed',
        token: @token,

        multipart: true
      },
      cookies: @jar
    )
  end
  # rubocop:enable Metrics/MethodLength

  def sign_up_crumb
    RestClient.get(@invite.slack_invite_url).cookies['b']
  end

  def change_email_crumb
    resp = RestClient.get(url_change_email, cookies: @jar)

    Nokogiri::HTML(resp).at_css('input[name="crumb"]')[:value]
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
    @team_subdomain ||= SlackClient::Team.info(
      Rails.application.secrets.slack_admin_access_token
    )[:team][:domain]
  end
end
