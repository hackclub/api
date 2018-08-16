# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::EventEmailSubscribers', type: :request do
  describe 'POST /v1/event_email_subscribers' do
    let(:params) { {} } # override in subtests

    before do
      perform_enqueued_jobs do
        post '/v1/event_email_subscribers', params: params
      end
    end

    it 'fails gracefully' do
      expect(response.status).to eq(422)
      expect(json['errors']['email']).to include("can't be blank")
    end

    context 'with valid params' do
      let(:params) do
        {
          email: 'foo@bar.com',
          location: 'Chicago, IL'
        }
      end

      it 'succeeds' do
        expect(response.status).to eq(201)
        expect(json['id']).to be_present
        expect(json['email']).to eq('foo@bar.com')

        # does not return sensitive fields
        expect(json['confirmation_token']).to_not be_present
        expect(json['unsubscribe_token']).to_not be_present

        # sent confirmation email
        expect(EventEmailSubscriberMailer.deliveries.length).to be(1)
      end
    end

    context 'with previously unsubscribed email' do
      let(:subscriber) { create(:event_email_subscriber_unsubscribed) }
      let(:params) do
        {
          email: subscriber.email,
          location: subscriber.location
        }
      end

      it 'updates the existing model' do
        expect(response.status).to eq(200)
        expect(json['id']).to eq(subscriber.id)

        # sent confirmation email
        expect(EventEmailSubscriberMailer.deliveries.length).to be(1)
      end
    end
  end

  describe 'GET /v1/event_email_subscribers/confirm?token=...' do
    let(:params) { {} } # override in subtests

    before { get '/v1/event_email_subscribers/confirm', params: params }

    it 'fails gracefully' do
      expect(response.status).to eq(422)
      expect(json['errors']['token']).to include("can't be blank")
    end

    context 'with invalid token' do
      let(:params) { { token: 'not a real token' } }

      it '404s' do
        expect(response.status).to eq(404)
      end
    end

    context 'with valid token' do
      let(:subscriber) { create(:event_email_subscriber) }
      let(:params) { { token: subscriber.confirmation_token } }

      it 'succeeds' do
        expect(response.status).to eq(200)
        expect(
          subscriber.reload.confirmed_at
        ).to be_within(1.minute).of(Time.current)
      end

      context 'when subscriber is already confirmed' do
        let(:subscriber) { create(:event_email_subscriber_confirmed) }

        it '404s' do
          expect(response.status).to eq(404)
        end
      end

      context 'when subscriber previously unsubscribed' do
        let(:subscriber) { create(:event_email_subscriber_unsubscribed) }

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(subscriber.reload.unsubscribed_at).to eq(nil)
        end
      end
    end
  end

  describe 'GET /v1/event_email_subscribers/unsubscribe?token=...' do
    let(:params) { {} } # override in subtests

    before do
      # so we can check if activemailer is triggered
      perform_enqueued_jobs do
        get '/v1/event_email_subscribers/unsubscribe', params: params
      end
    end

    it 'fails gracefully' do
      expect(response.status).to eq(422)
      expect(json['errors']['token']).to include("can't be blank")
    end

    context 'with invalid token' do
      let(:params) { { token: 'not a real token' } }

      it '404s' do
        expect(response.status).to eq(404)
      end
    end

    context 'with valid token' do
      let(:subscriber) { create(:event_email_subscriber_confirmed) }
      let(:params) { { token: subscriber.unsubscribe_token } }

      it 'succeeds' do
        expect(response.status).to eq(200)
        expect(
          subscriber.reload.unsubscribed_at
        ).to be_within(1.minute).of(Time.current)

        # sends email confirming unsubscription
        expect(EventEmailSubscriberMailer.deliveries.length).to be(1)
      end

      context 'when subscriber has already unsubscribed' do
        let(:subscriber) { create(:event_email_subscriber_unsubscribed) }

        it '404s' do
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
