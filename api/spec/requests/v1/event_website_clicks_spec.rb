# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::EventWebsiteClicks', type: :request do
  describe 'GET /v1/events/:id/redirect' do
    let(:event) { create(:event) }

    # override in subtests
    let(:params) { {} }
    let(:headers) { {} }

    before do
      get "/v1/events/#{event.id}/redirect",
          params: params,
          headers: headers
    end

    it "redirects to event's website" do
      expect(response.status).to eq(302)
      expect(response.headers['Location']).to eq(event.website)
    end

    it 'creates a new EventWebsiteClick' do
      click = EventWebsiteClick.last

      expect(click.event).to eq(event)
      expect(click.ip_address).to be_present
    end

    context 'when user agent is set' do
      let(:headers) { { 'User-Agent' => 'Test Agent' } }

      it 'saves it' do
        expect(EventWebsiteClick.last.user_agent).to eq('Test Agent')
      end
    end

    context 'when referer is set' do
      let(:headers) { { 'HTTP_REFERER' => 'example.com' } }

      it 'saves it' do
        expect(EventWebsiteClick.last.referer).to eq('example.com')
      end
    end

    context 'when token is set' do
      let(:subscriber) { create(:event_email_subscriber_confirmed) }
      let(:params) { { token: subscriber.link_tracking_token } }

      it 'associates the subscriber' do
        expect(EventWebsiteClick.last.email_subscriber).to eq(subscriber)
      end
    end
  end
end
