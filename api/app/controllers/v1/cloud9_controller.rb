# frozen_string_literal: true
module V1
  class Cloud9Controller < ApiController
    def send_invite
      invite = Cloud9Invite.new(invite_params)

      if invite.save
        render_success
      else
        render_field_errors(invite.errors)
      end
    end

    protected

    def invite_params
      params.permit(:email)
    end
  end
end
