# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/leadership_position_invite
class LeadershipPositionInvitePreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/leadership_position_invite/notify_invitee
  def notify_invitee
    invite = FactoryBot.create(:leadership_position_invite)

    LeadershipPositionInviteMailer.with(invite: invite).notify_invitee
  end
end
