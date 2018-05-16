# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/challenge_post_comment_mailer
class ChallengePostCommentMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/challenge_post_comment_mailer/notify_post_creator
  def notify_post_creator
    comment = FactoryBot.create(:challenge_post_comment)

    ChallengePostCommentMailer.with(comment: comment).notify_post_creator
  end
end
