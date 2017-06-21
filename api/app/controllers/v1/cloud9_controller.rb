module V1
  class Cloud9Controller < ApplicationController
    def send_invite
      invite = Cloud9Invite.new(invite_params)

      if invite.save
        render json: { success: true }
      else
        render json: { errors: invite.errors }, status: 422
      end
    end

    protected

    def invite_params
      params.permit(:email)
    end
  end
end
