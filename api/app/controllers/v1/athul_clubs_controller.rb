# frozen_string_literal: true

module V1
  class AthulClubsController < ApiController
    AUTH_TOKEN = Rails.application.secrets.athul_auth_token

    def create
      club = AthulClub.new(club_attributes: club_params,
                           leader_attributes: leader_params)

      if !authenticated?
        render_field_error(:base, 'missing / invalid authentication', 401)
      elsif club.save
        render_success(club, 201)
      else
        render_field_errors(club.errors)
      end
    end

    private

    def authenticated?
      params[:auth_token] == AUTH_TOKEN
    end

    def club_params
      params.require(:club).permit(:name, :address)
    end

    def leader_params
      params.require(:leader).permit(
        :name, :email, :gender, :year, :phone_number, :github_username,
        :twitter_username, :address
      )
    end
  end
end
