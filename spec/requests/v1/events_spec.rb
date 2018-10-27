# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Events', type: :request do
  let(:user) { nil } # set this in subtests
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  describe 'GET /v1/events' do
    before { 5.times { create(:event_w_photos) } }

    it 'properly lists events' do
      get '/v1/events'
      expect(response.status).to eq(200)

      # returns all events
      expect(json.length).to eq(5)

      # returns proper attributes
      expect(json[0]).to include(
        'id',
        'created_at',
        'updated_at',
        'start',
        'end',
        'name',
        'public',
        'website',
        'website_redirect',
        'hack_club_associated',
        'mlh_associated',
        'collegiate',
        'address',
        'latitude',
        'longitude',
        'parsed_address',
        'parsed_city',
        'parsed_state',
        'parsed_state_code',
        'parsed_postal_code',
        'parsed_country',
        'parsed_country_code',
        'group_id'
      )
      expect(json[0]['logo']).to include(
        'id', 'created_at', 'updated_at', 'file_path',
        'type' => 'event_logo'
      )
      expect(json[0]['banner']).to include(
        'id', 'created_at', 'updated_at', 'file_path',
        'type' => 'event_banner'
      )

      # excludes bad fields for regular users
      expect(json[0]).to_not include(
        'hack_club_associated_notes',
        'total_attendance',
        'first_time_hackathon_estimate'
      )
    end

    it 'does not return non-public events' do
      create(:event_w_photos, public: false)

      get '/v1/events'

      # only returns public events
      expect(json.length).to eq(5)
    end

    context 'as admin' do
      let(:user) { create(:user_admin_authed) }

      it 'includes hidden fields' do
        get '/v1/events', headers: auth_headers

        expect(json[0]).to include(
          'hack_club_associated_notes',
          'total_attendance',
          'first_time_hackathon_estimate'
        )
      end

      it 'includes non-public events' do
        create(:event_w_photos, public: false)

        get '/v1/events', headers: auth_headers

        # also returns private events
        expect(json.length).to eq(6)
        expect(json.first).to include('public' => false)
      end
    end
  end

  describe 'POST /v1/events' do
    let(:user) { create(:user_authed) }

    it 'requires authentication' do
      post '/v1/events'
      expect(response.status).to eq(401)
    end

    it 'requires admin' do
      post '/v1/events', headers: auth_headers
      expect(response.status).to eq(403)
    end

    context 'as admin' do
      let(:user) { create(:user_admin_authed) }

      it 'successfully creates new events' do
        expect do
          post '/v1/events',
               headers: auth_headers,
               params: attributes_for(:event)
        end.to change { Event.count }.by(1)
      end

      it 'allows setting the proper fields' do
        post '/v1/events',
             headers: auth_headers,
             params: {
               start: 3.days.from_now,
               end: 4.days.from_now,
               name: 'TestHacks',
               public: false,
               website: 'https://example.com',
               hack_club_associated: true,
               hack_club_associated_notes: 'Just testing!',
               mlh_associated: true,
               collegiate: true,
               total_attendance: 100,
               first_time_hackathon_estimate: 120,
               address: 'Test Address'
             }

        expect(response.status).to eq(201)
        expect(json).to include(
          'start' => 3.days.from_now.to_date.to_s,
          'end' => 4.days.from_now.to_date.to_s,
          'name' => 'TestHacks',
          'public' => false,
          'website' => 'https://example.com',
          'hack_club_associated' => true,
          'hack_club_associated_notes' => 'Just testing!',
          'mlh_associated' => true,
          'collegiate' => true,
          'total_attendance' => 100,
          'first_time_hackathon_estimate' => 120,
          'address' => 'Test Address'
        )
      end

      it 'throws validation errors when needed' do
        post '/v1/events',
             headers: auth_headers,
             params: {
               name: 'Test'
             }

        expect(response.status).to eq(422)
        expect(json['errors']).to include('address')
      end
    end
  end

  describe 'PATCH /v1/events/:id' do
    let(:event) { create(:event) }

    it 'requires authentication' do
      patch "/v1/events/#{event.id}", params: { name: 'TestEvent' }
      expect(response.status).to eq(401)
    end

    context 'when authenticated as non-admin' do
      let(:user) { create(:user_authed) }

      it 'fails' do
        patch "/v1/events/#{event.id}",
              headers: auth_headers,
              params: { name: 'TestEvent' }
        expect(response.status).to eq(403)
      end
    end

    context 'when authenticated as admin' do
      let(:user) { create(:user_admin_authed) }

      context 'with valid params' do
        let(:params) { { name: 'TestEvent' } }

        before do
          patch "/v1/events/#{event.id}",
                headers: auth_headers,
                params: params
        end

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(json['name']).to eq('TestEvent')
        end

        context 'and trying to update banner / logo' do
          let(:logo) { create(:event_logo) }
          let(:banner) { create(:event_banner) }

          let(:params) do
            {
              logo_id: logo.id,
              banner_id: banner.id
            }
          end

          it 'successfully updates' do
            expect(response.status).to eq(200)
            expect(json['logo']['id']).to eq(logo.id)
            expect(json['banner']['id']).to eq(banner.id)
          end
        end
      end

      context 'with invalid params' do
        let(:params) { { name: nil } }

        before do
          patch "/v1/events/#{event.id}",
                headers: auth_headers,
                params: params
        end

        it 'fails gracefully' do
          expect(response.status).to eq(422)
          expect(json['errors']).to include('name')
        end
      end
    end
  end

  describe 'DELETE /v1/events/:id' do
    let(:event) { create(:event) }

    let(:headers) { {} }

    before { delete "/v1/events/#{event.id}", headers: headers }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires admin' do
        expect(response.status).to eq(403)
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(Event.find_by(id: event.id)).to eq(nil)
        end
      end
    end
  end
end
