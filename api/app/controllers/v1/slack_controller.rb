module V1
  class SlackController < ApplicationController
    def send_invite
      invite = SlackInvite.new(invite_params)

      if invite.save
        render json: invite, status: 201
      else
        render json: { errors: invite.errors }, status: 422
      end
    end

    private

    def invite_params
      params.permit(:email)
    end
  end
end
