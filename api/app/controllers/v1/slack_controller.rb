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

    def create_account
      invite = SlackInvite.create

      invite.send

      render json: {params: account_params, invite: invite}
    end

    private

    def account_params
      params.permit(:email, :username, :password)
    end
  end
end
