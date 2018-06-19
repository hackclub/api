# frozen_string_literal: true

module V1
  class NewClubsController < ApiController
    include UserAuth

    def index
      return render_access_denied unless current_user.admin?

      render_success NewClub.all
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
