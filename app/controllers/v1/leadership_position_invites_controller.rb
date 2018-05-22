module V1
  class LeadershipPositionInvitesController < ApiController
    include UserAuth

    def accept
      id = params[:leadership_position_invite_id]
      invite = LeadershipPositionInvite.find(id)
      return access_denied unless current_user == invite.user
      return render_field_error(:base, 'already processed') unless invite.accepted_at.nil? && invite.rejected_at.nil?
      return render_field_error(:new_leader, 'must be present') unless current_user.new_leader.present?

      position = LeadershipPosition.create(
        new_club: invite.new_club,
        new_leader: current_user.new_leader
      )

      invite.leadership_position = position
      invite.accepted_at = Time.current
      invite.save

      render_success invite
    end

    def reject
      id = params[:leadership_position_invite_id]
      invite = LeadershipPositionInvite.find(id)
      return access_denied unless current_user == invite.user
      return render_field_error(:base, 'already processed') unless invite.accepted_at.nil? && invite.rejected_at.nil?

      invite.rejected_at = Time.current
      invite.save

      render_success invite
    end
  end
end
