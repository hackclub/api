# frozen_string_literal: true
module V1
  class ClubsController < ApiController
    before_action :find_club, only: [:show]

    def index
      render_success(Club.select(&:alive?))
    end

    def show
      return render_not_found if @club.nil?

      render_success(@club)
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
