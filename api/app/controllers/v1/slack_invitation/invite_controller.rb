module V1
  module SlackInvitation
    class InviteController < ApplicationController
      def create
        invite = SlackInvite.create(invite_params)

        if !invite.save
          return render json: invite.errors
        end

        invite.send

        render json: invite, status: 200
      end

      private

      def invite_params
        params.permit(:email, :username, :full_name, :password)
      end
    end
  end
end
