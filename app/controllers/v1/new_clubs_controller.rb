# frozen_string_literal: true

module V1
  class NewClubsController < ApiController
    include UserAuth

    def index
      return render_access_denied unless current_user.admin?

      render_success NewClub.all
    end
  end
end
