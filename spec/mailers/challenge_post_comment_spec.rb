# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChallengePostCommentMailer, type: :mailer do
  describe 'notify_post_creator' do
    let(:comment) { create(:challenge_post_comment) }
    let(:post) { comment.challenge_post }
    let(:mail) do
      ChallengePostCommentMailer
        .with(comment: comment)
        .notify_post_creator
    end

    it 'renders the headers' do
      expect(mail.subject).to include(post.name)
      expect(mail.to).to eq([post.creator.email])
    end

    it 'renders the body' do
      expect(mail).to have_body_text(comment.user.email)
      expect(mail).to have_body_text(comment.body)
    end
  end
end
