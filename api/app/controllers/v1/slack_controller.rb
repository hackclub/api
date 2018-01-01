# frozen_string_literal: true

module V1
  class SlackController < ApiController
    def send_invite
      invite = SlackInvite.new(invite_params)

      if invite.save
        render_success(invite, 201)
      else
        render_field_errors(invite.errors)
      end
    end

    def create_account
      invite = SlackInvite.create
      invite.send

      render_success(params: account_params, invite: invite)
    end

    private

    def account_params
      params.permit(:email, :username, :password)
    end
  end
end
