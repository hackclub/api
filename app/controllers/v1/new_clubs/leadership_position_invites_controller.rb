# frozen_string_literal: true

module V1
  module NewClubs
    class LeadershipPositionInvitesController < ApiController
      include UserAuth

      def create
        email = params[:email]&.downcase
        return render_field_error(:email, 'is required') unless email

        club = NewClub.find(params[:new_club_id])
        user = User.find_or_initialize_by(email: email)

        invite = LeadershipPositionInvite.new(
          sender: current_user,
          new_club: club,
          user: user
        )
        authorize invite

        if invite.save
          LeadershipPositionInviteMailer
            .with(invite: invite)
            .notify_invitee
            .deliver_later

          render_success(success: true)
        else
          render_field_errors invite.errors
        end
      end
    end
  end
end
