# frozen_string_literal: true

class WorkshopFeedbackPreview < ActionMailer::Preview
  def admin_notification
    feedback = FactoryBot.create(:workshop_feedback)
    WorkshopFeedbackMailer.admin_notification(feedback)
  end
end
