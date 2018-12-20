# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/challenge_post_mailer
class ChallengePostMailerPreview < ActionMailer::Preview
  # Preview all emails at http://localhost:3000/rails/mailers/challenge_post_mailer/notify_creator
  def notify_creator
    post = FactoryBot.create(:challenge_post)

    ChallengePostMailer.with(post: post).notify_creator
  end
end
