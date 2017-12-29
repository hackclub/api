# frozen_string_literal: true
module V1
  module SlackInvitation
    class InviteController < ApplicationController
      def create
        invite = ::SlackInvite.create(
          invite_params.merge(team: team)
        )

        return render json: invite.errors unless invite.save

        invite.dispatch

        render json: strip(invite), status: 200
      end

      def show
        invite = ::SlackInvite.find(params[:id])

        render json: strip(invite), status: 200
      end

      private

      def invite_params
        params.permit(:email, :username, :full_name, :password,
                      :slack_invite_strategy_id)
      end

      def strip(inv)
        inv.to_json(methods: [:temp_email], only: [:id, :state])
      end

      def team
        ::Hackbot::Team.find_by(
          team_id: Rails.application.secrets.default_slack_team_id
        )
      end
    end
  end
end
