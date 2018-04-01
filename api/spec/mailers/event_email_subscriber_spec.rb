# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventEmailSubscriberMailer, type: :mailer do
  describe 'confirm_email' do
    let(:subscriber) { create(:event_email_subscriber) }
    let(:mail) { EventEmailSubscriberMailer.confirm_email(subscriber) }

    it 'is from hackathons@hackclub.com' do
      email = 'Hack Club Hackathons <hackathons@hackclub.com>'
      expect(mail).to deliver_from(email)
      expect(mail).to reply_to(email)
    end

    it 'is sent to subscriber' do
      expect(mail).to deliver_to(subscriber.email)
    end

    it 'includes confirmation token' do
      expect(mail).to have_body_text(subscriber.confirmation_token)
    end
  end

  describe 'new_event' do
    let(:subscriber) { create(:event_email_subscriber_confirmed) }
    let(:event) { create(:event) }
    let(:mail) { EventEmailSubscriberMailer.new_event(subscriber, event) }

    it 'is from hackathons@hackclub.com' do
      email = 'Hack Club Hackathons <hackathons@hackclub.com>'
      expect(mail).to deliver_from(email)
      expect(mail).to reply_to(email)
    end

    it 'is sent to subscriber' do
      expect(mail).to deliver_to(subscriber.email)
    end

    it 'includes unsubscribe token' do
      expect(mail).to have_body_text(subscriber.unsubscribe_token)
    end

    it 'includes event info' do
      expect(mail).to have_body_text(event.name)
      expect(mail).to have_body_text(event.website)
    end
  end

  describe 'unsubscribe' do
    let(:subscriber) { create(:event_email_subscriber_unsubscribed) }
    let(:mail) { EventEmailSubscriberMailer.unsubscribe(subscriber) }

    it 'is from hackathons@hackclub.com' do
      email = 'Hack Club Hackathons <hackathons@hackclub.com>'
      expect(mail).to deliver_from(email)
      expect(mail).to reply_to(email)
    end

    it 'is sent to subscriber' do
      expect(mail).to deliver_to(subscriber.email)
    end
  end
end
