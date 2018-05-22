# frozen_string_literal: true

class LeadershipPositionInviteMailer < ApplicationMailer
  def notify_invitee
    @invite = params[:invite]
    @sender = @invite.sender
    @club = @invite.new_club

    school = @club.high_school_name

    mail to: @invite.user.email,
         subject: "Confirm your invite to the Hack Club at #{school}"
  end
end
