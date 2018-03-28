# frozen_string_literal: true

class WorkshopFeedbackMailer < ApplicationMailer
  def admin_notification(workshop_feedback)
    @feedback = workshop_feedback

    mail to: 'Workshops Team <workshops@hackclub.com>',
         subject: 'New Workshop Feedback Received!'
  end
end
