# frozen_string_literal: true

module V1
  class SlackInvitesController < ApiController
    def create
      invite = SlackInvite.new(email: params[:email])

      if invite.save
        render_success invite, 201
      else
        render_field_errors invite.errors
      end
    end
  end
end
