module V1
  class ClubsController < ApplicationController
    before_action :find_club, only: [:show, :update, :destroy]

    def index
      render json: Club.all
    end

    def create
      club = Club.new(club_params)

      if club.save
        render json: club, status: 201
      else
        render json: { errors: club.errors }, status: 422
      end
    end

    def show
      if @club.nil?
        render(json: { error: 'Club not found' }, status: 404) && return
      end

      render json: @club
    end

    def update
      if @club.nil?
        render(json: { error: 'Club not found' }, status: 404) && return
      end

      if @club.update_attributes(club_params)
        render json: @club, status: 200
      else
        render json: { errors: @club.errors }, status: 422
      end
    end

    def destroy
      if @club
        @club.destroy

        render json: { status: 'success' }, status: 200
      else
        render json: { error: 'Club not found' }, status: 404
      end
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
