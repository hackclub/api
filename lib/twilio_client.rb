# frozen_string_literal: true

module TwilioClient
  class << self
    ACCOUNT_SID = Rails.application.secrets.twilio_account_sid
    AUTH_TOKEN = Rails.application.secrets.twilio_auth_token
    FROM_NUMBER = '+14158532126'

    TWILIO = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN)

    def send_login_code(user)
      TWILIO.messages.create(
        from: FROM_NUMBER,
        to: user.e164_phone_number,
        body: "Your Hack Club login code is #{user.pretty_login_code}.\n
        It will expire in 15 minutes."
      )
    end
  end
end
