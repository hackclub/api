class HandleSpamClubApplicationsJob < ApplicationJob
  INBOX_STAGE = '5001'.freeze
  REJECTED_STAGE = '5002'.freeze

  SPAM_COMMENT_MESSAGE = 'Automatically moving box to rejected and marking as '\
    'spam due to our filter thinking this is spam. Note: this does not send '\
    'any  sort of email notification to the applicant letting them know that '\
    "we're rejecting / ignoring them.".freeze

  def perform_now
    ClubApplication
      .where(stage_key: INBOX_STAGE)
      .select(&:spam?)
      .ca do |ca|
        StreakClient::Box.comment(ca, SPAM_COMMENT_MESSAGE)

        ca.stage_key = REJECTED_STAGE
        ca.save
      end
  end
end
