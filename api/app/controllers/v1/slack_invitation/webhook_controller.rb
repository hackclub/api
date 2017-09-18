module V1
  module SlackInvitation
    class WebhookController < ApplicationController
      SLACK_SIGN_UP_URL = "https://hackclub.slack.com/api/signup.createUser".freeze
      SLACK_USER_PREFS_URL = "https://hackclub.slack.com/api/users.prefs.set".freeze
      SLACK_CONVERSATIONS_READ_URL = "https://hackclub.slack.com/api/conversations.mark".freeze
      SLACK_CHANGE_EMAIL_URL = "https://hackclub.slack.com/account/settings".freeze
      SLACK_THEME="&sidebar_theme=custom_theme&sidebar_theme_custom_values=%7B%22column_bg%22%3A%22%23ffffff%22%2C%22menu_bg%22%3A%22%23f9d5d9%22%2C%22active_item%22%3A%22%23e42d42%22%2C%22active_item_text%22%3A%22%23ffffff%22%2C%22hover_item%22%3A%22%23f9d5d9%22%2C%22text_color%22%3A%22%23e42d42%22%2C%22active_presence%22%3A%22%2328ce68%22%2C%22badge%22%3A%22%232d9ee4%22%7D".freeze

      DEFAULT_CHANNEL_ID="C745G5N2Y".freeze

      def create
        @invite = SlackInvite.find invitation_id
        if @invite.nil?
          render json: {invite: nil}, status: 422
          return
        end

        unless slack_invite_url
          render json: {invite: nil}, status: 422
          return
        end

        @invite.slack_invite_id = slack_invite_id

        @invite.state = 'invite_received'
        @invite.save

        resp = sign_up

        @jar = resp.cookies
        data = JSON.parse(resp)
        @token = data["api_token"]

        set_user_pref 'seen_welcome_2', 'true'
        set_user_pref 'onboarding_cancelled', 'true'

        set_theme SLACK_THEME

        go_to_channel(DEFAULT_CHANNEL_ID)

        @invite.state = 'client_configured'
        @invite.save

        change_email

        @invite.state = 'email_changed'
        @invite.save
      end

      private

      def slack_invite_id
        slack_invite_url.match(/\/invite\/(\w+)\?/)[1]
      end

      def slack_invite_url
        Nokogiri::HTML(body_html)
          .xpath('//a')
          .find {|l| l.text.strip == "Join Now"}
          .try { |l| l['href'] }
      end

      def invitation_id
        recipient.match(/slack\+(\d+)\@mail\.hackclub\.com/)[1].to_i
      end

      def body_html
        params["body-html"]
      end

      def recipient
        params["recipient"]
      end

      def sign_up
        RestClient.post(
          SLACK_SIGN_UP_URL,
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
          SLACK_USER_PREFS_URL,
          {
            name: key,
            value: value,
            token: @token,

            multipart: true
          },
          cookies: @jar
        )
      end

      def set_theme(prefs)
        RestClient.post(
          SLACK_USER_PREFS_URL,
          {
            name: prefs,
            token: @token,

            multipart: true
          },
          cookies: @jar
        )
      end

      def go_to_channel(channel_id)
        RestClient.post(
          SLACK_CONVERSATIONS_READ_URL,
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

      def change_email
        RestClient.post(
          SLACK_CHANGE_EMAIL_URL,
          {
            change_email: 1,
            crumb: change_email_crumb,
            email_password: @invite.password,
            new_email: @invite.email,
          },
          cookies: @jar,
        )
      rescue RestClient::Found=>e;
        # We want Slack to give us a 302 (NotFound)
        
        e.response
      end

      def sign_up_crumb
        RestClient.get(@invite.slack_invite_url).cookies["b"]
      end

      def change_email_crumb
        resp = RestClient.get("https://hackclub.slack.com/account/settings", cookies: @jar)

        Nokogiri::HTML(resp).at_css("input[name=\"crumb\"]")[:value]
      end
    end
  end
end
