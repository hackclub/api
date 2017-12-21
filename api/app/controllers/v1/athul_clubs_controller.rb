module V1
  class AthulClubsController < ApplicationController
    AUTH_TOKEN = Rails.application.secrets.athul_auth_token

    def create
      club = AthulClub.new(club_attributes: club_params,
                           leader_attributes: leader_params)

      if !authenticated?
        render json: { errors: { base: 'missing / invalid authentication' } },
               status: 401
      elsif club.save
        render json: club, status: 201
      else
        render json: { errors: club.errors }, status: 422
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
