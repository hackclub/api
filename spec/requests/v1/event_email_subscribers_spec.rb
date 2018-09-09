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

  describe 'GET /v1/event_email_subscribers/stats' do
    let(:setup) {}

    before do
      setup
      get '/v1/event_email_subscribers/stats'
    end

    it 'returns no cities & no countries' do
      expect(response.status).to eq(200)
      expect(json['cities']).to eq(0)
      expect(json['countries']).to eq(0)
    end

    context 'with 5 cities and 3 countries' do
      def create_subscriber(
        location,
        subscriber_type = :event_email_subscriber_confirmed
      )
        subscriber = create(
          subscriber_type,
          location: "#{location[0]}, #{location[1]}"
        )

        # since we spec out geocoding for tests to return fake results,
        # manually override the geocoded city & country
        subscriber.update(
          parsed_city: location[0],
          parsed_country: location[1]
        )
      end

      let(:locations) do
        [
          ['Los Angeles', 'United States'],
          ['San Francisco', 'United States'],
          ['New York City', 'United States'],
          %w[Tokyo Japan],
          %w[Maputo Mozambique]
        ]
      end

      let(:setup) { locations.each { |l| create_subscriber(l) } }

      it 'returns the correct number of cities and countries' do
        expect(response.status).to eq(200)
        expect(json['cities']).to eq(5)
        expect(json['countries']).to eq(3)
      end

      context 'with an unconfirmed email subscriber' do
        let(:setup) do
          locations.each { |l| create_subscriber(l) }
          create_subscriber(
            %w[Paris France],
            :event_email_subscriber # not confirmed
          )
        end

        it 'does not count them' do
          expect(response.status).to eq(200)
          expect(json['cities']).to eq(5)
          expect(json['countries']).to eq(3)
        end
      end

      context 'with an unsubscribed email subscriber' do
        let(:setup) do
          locations.each { |l| create_subscriber(l) }
          create_subscriber(
            %w[Paris France],
            :event_email_subscriber_unsubscribed
          )
        end

        it 'does not count them' do
          expect(response.status).to eq(200)
          expect(json['cities']).to eq(5)
          expect(json['countries']).to eq(3)
        end
      end
    end
  end
end
