# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePostMailer, type: :mailer do
  describe 'notify_creator' do
    let(:post) { create(:challenge_post) }
    let(:mail) do
      ChallengePostMailer
        .with(post: post)
        .notify_creator
    end

    it 'renders the headers' do
      expect(mail.subject).to include(post.name)
      expect(mail.to).to eq([post.creator.email])
    end

    it 'renders the body' do
      expect(mail).to have_body_text(post.name)
    end
  end
end
