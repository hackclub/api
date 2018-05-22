# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadershipPositionInviteMailer, type: :mailer do
  describe 'notify_invitee' do
    let(:invite) { create(:leadership_position_invite) }
    let(:club) { invite.new_club }

    let(:mail) do
      LeadershipPositionInviteMailer.with(invite: invite).notify_invitee
    end

    it 'renders the headers' do
      expect(mail).to deliver_to(invite.user.email)
    end

    it 'renders the body' do
      expect(mail).to have_body_text(/#{club.high_school_name}/)
    end
  end
end
