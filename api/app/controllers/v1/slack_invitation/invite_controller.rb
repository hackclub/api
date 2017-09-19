module V1
  module SlackInvitation
    class InviteController < ApplicationController
      def create
        invite = SlackInvite.create(invite_params)

        return render json: invite.errors unless invite.save

        invite.dispatch

        render json: strip(invite), status: 200
      end

      def show
        invite = SlackInvite.find(params[:id])

        render json: strip(invite), status: 200
      end

      private

      def invite_params
        params.permit(:email, :username, :full_name, :password)
      end

      def strip(inv)
        inv.to_json(methods: [:temp_email], only: [:id, :state])
      end
    end
  end
end
