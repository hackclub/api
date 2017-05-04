module V1
  class LeadersController < ApplicationController
    before_action :verify_club_id, only: :intake

    TEAM_ID = Rails.application.secrets.default_slack_team_id

    def intake
      leader = Leader.new(
        leader_params.merge(club_ids: [club_id], slack_team_id: TEAM_ID)
      )

      if leader.save
        welcome_to_slack leader

        render json: leader, status: 201
      else
        render json: { errors: leader.errors }, status: 422
      end
    end

    protected

    def club_id
      params[:club_id]
    end

    def verify_club_id
      return unless club_id.nil?
      render json: { errors: { club_id: ["can't be blank"] } }, status: 422
    end

    def leader_params
      params.permit(
        :name, :email, :gender, :year, :phone_number, :slack_username,
        :github_username, :twitter_username, :address
      )
    end

    def welcome_to_slack(leader)
      ::Hackbot::Interactions::Welcome.trigger(leader.slack_id)
    end
  end
end
