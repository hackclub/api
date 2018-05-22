# frozen_string_literal: true

module V1
  class LeadershipPositionInvitesController < ApiController
    include UserAuth

    def accept
      id = params[:leadership_position_invite_id]
      invite = LeadershipPositionInvite.find(id)
      authorize invite

      if invite.accept!
        render_success invite
      else
        render_field_errors invite.errors
      end
    end

    def reject
      id = params[:leadership_position_invite_id]
      invite = LeadershipPositionInvite.find(id)
      authorize invite

      if invite.reject!
        render_success invite
      else
        render_field_errors invite.errors
      end
    end
  end
end
