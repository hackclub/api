# frozen_string_literal: true

require 'twilio-ruby'

class TwilioVerificationService
  CLIENT = Twilio::REST::Client.new(
    Rails.application.secrets.twilio_account_sid,
    Rails.application.secrets.twilio_api_key
  )
  VERIFY_SERVICE_ID = 'VAa06a66dad4c1ca3c199a46334ff11945'

  def send_verification_request(phone_number)
    CLIENT.verify
          .services(VERIFY_SERVICE_ID)
          .verifications
          .create(to: phone_number, channel: 'sms')
  end

  def check_verification_token(phone_number, code)
    verification = CLIENT.verify
                         .services(VERIFY_SERVICE_ID)
                         .verification_checks
                         .create(to: phone_number, code: code)
    verification.status == 'approved'
  end
end
