# frozen_string_literal: true

module V1
  class LeadershipPositionsController < ApiController
    include UserAuth

    # pass deleted_at=nil to undelete the given leadership position
    def update
      # don't handle non undelete cases for now. be careful to ensure you don't
      # allow people to update fields of undeleted records if this changes.
      unless params.key?(:deleted_at) && params[:deleted_at].nil?
        return render_error(
          'this endpoint is for undeleting leadership positions',
          422
        )
      end

      position = LeadershipPosition.with_deleted.find(params[:id])
      authorize position

      # do the actual undelete, again - this logic will have to change if you
      # start adding more functionality to the endpoint
      position.restore

      render_success position
    end

    def destroy
      position = LeadershipPosition.find(params[:id])
      authorize position

      position.destroy

      render_success position
    end
  end
end
