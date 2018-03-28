# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkshopFeedbackMailer, type: :mailer do
  describe 'admin_notification' do
    let(:feedback) { create(:workshop_feedback) }
    let(:mail) { WorkshopFeedbackMailer.admin_notification(feedback) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New Workshop Feedback Received!')
      expect(mail).to deliver_to('Workshops Team <workshops@hackclub.com>')
    end

    it 'renders the body' do
      expect(mail).to have_body_text(feedback.workshop_slug)
      expect(mail).to have_body_text(feedback.ip_address.to_s)

      feedback.feedback.each do |question, answer|
        expect(mail).to have_body_text(question)
        expect(mail).to have_body_text(answer)
      end
    end
  end
end
