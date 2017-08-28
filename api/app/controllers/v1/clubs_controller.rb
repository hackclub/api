module V1
  class ClubsController < ApplicationController
    before_action :find_club, only: [:show]

    def index
      render json: Club.select(&:alive?)
    end

    def show
      if @club.nil?
        render(json: { error: 'Club not found' }, status: 404) && return
      end

      render json: @club
    end

    protected

    def club_params
      params.permit(:name, :address, :source, :notes)
    end

    def find_club
      @club = Club.find_by(id: params[:id])
    end
  end
end
