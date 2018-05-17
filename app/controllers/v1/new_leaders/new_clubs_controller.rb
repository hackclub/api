# frozen_string_literal: true

module V1
  module NewLeaders
    class NewClubsController < ApiController
      include UserAuth

      def index
        leader = NewLeader.find(params[:new_leader_id])

        unless leader.user == current_user || current_user.admin?
          return render_access_denied
        end

        render_success leader.new_clubs
      end
    end
  end
end
