class V1::ClubsController < ApplicationController
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
    club = Club.find_by_id(params[:id])

    if club
      render json: club
    else
      render json: { error: "Club not found" }, status: 404
    end
  end

  def update
    club = Club.find_by_id(params[:id])

    if club
      if club.update_attributes(club_params)
        render json: club, status: 200
      else
        render json: { errors: club.errors }, status: 422
      end
    else
      render json: { error: "Club not found" }, status: 404
    end
  end

  def destroy
    club = Club.find_by_id(params[:id])

    if club
      club.destroy

      render json: { status: "success" }, status: 200
    else
      render json: { error: "Club not found" }, status: 404
    end
  end

  protected

  def club_params
    params.permit(:name, :address, :source, :notes)
  end
end
