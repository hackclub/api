require 'twilio-ruby'

class SMSLoginCodeService
    def initialize(login_code)
        @login_code = login_code
    end

    def call
        client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"])

        client.messages.create(
            from: ENV["TWILIO_NUMBER"],
            to: @login_code.user.phone,
            body: "Your Hack Club login code is: #{@login_code.pretty}"
        )
    end
end