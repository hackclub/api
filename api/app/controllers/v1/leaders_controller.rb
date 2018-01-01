# frozen_string_literal: true
module V1
  class LeadersController < ApiController
    before_action :verify_club_id, only: :intake

    TEAM_ID = Rails.application.secrets.default_slack_team_id

    def intake
      leader = Leader.new(
        leader_params.merge(club_ids: [club_id], slack_team_id: TEAM_ID,
                            slack_id: slack_id)
      )

      if leader.save
        welcome_to_slack leader

        render_success(leader, 201)
      else
        render_field_errors(leader.errors)
      end
    end

    protected

    def club_id
      params[:club_id]
    end

    def slack_id
      token = ::Hackbot::Team.find_by(team_id: TEAM_ID).bot_access_token

      SlackClient::Users
        .list(token)[:members]
        .find { |u| u[:profile][:email] == params[:email] }[:id]
    end

    def verify_club_id
      return unless club_id.nil?
      render_field_error(:club_id, "can't be blank")
    end

    def leader_params
      params.permit(
        :name, :email, :gender, :year, :phone_number, :github_username,
        :twitter_username, :address
      )
    end

    def welcome_to_slack(leader)
      ::Hackbot::Interactions::Welcome.trigger(leader.slack_id)
    end
  end
end
