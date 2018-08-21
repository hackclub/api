# frozen_string_literal: true

module V1
  class NewClubsController < ApiController
    USER_AUTH = { except: :index }.freeze
    include UserAuth

    def index
      authenticate_user if request.headers.include? 'Authorization'
      return if performed? # make sure we don't double render if auth failed

      clubs = NewClub.all

      if current_user&.admin?
        render_success clubs
      else
        pairs = clubs.pluck(:high_school_latitude, :high_school_longitude)
        objs = pairs.map do |p|
          { high_school_latitude: p[0], high_school_longitude: p[1] }
        end

        render_success objs
      end
    end

    # list owned clubs
    def index_owned
      render_success current_user.owned_clubs
    end

    def show
      club = NewClub.find(params[:id])
      authorize club

      render_success club
    end

    def update
      club = NewClub.find(params[:id])
      authorize club

      if club.update_attributes(club_params(club))
        render_success club
      else
        render_field_errors club.errors
      end
    end

    ## TEMP ACTION - MUST BE REMOVED ##
    def check_ins_index
      new_club = NewClub.find(params[:new_club_id])
      authorize new_club

      render_success(new_club&.club&.check_ins || [])
    end

    private

    def club_params(club)
      params.permit(policy(club).permitted_attributes)
    end
  end
end
