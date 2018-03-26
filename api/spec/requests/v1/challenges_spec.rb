# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Challenge', type: :request do
  describe 'GET /v1/challenges' do
    before { 5.times { create(:challenge) } }

    it 'successfully returns all challenges' do
      get '/v1/challenges'

      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end
  end

  describe 'POST /v1/challenges' do
    let(:user) { create(:user_authed) }
    let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

    it 'requires authentication' do
      post '/v1/challenges'
      expect(response.status).to eq(401)
    end

    it 'requires user to be an admin' do
      post '/v1/challenges', headers: auth_headers
      expect(response.status).to eq(403)
    end

    context 'as admin' do
      let(:user) { create(:user_admin_authed) }

      it 'creates with all attributes' do
        post '/v1/challenges',
             headers: auth_headers,
             params: {
               name: '90s Website',
               description: 'Build the most...',
               start: '2018-03-31',
               end: '2018-04-12'
             }

        expect(response.status).to eq(201)
        expect(json).to include(
          'id',
          'created_at',
          'updated_at',
          'name',
          'description',
          'start',
          'end',
          'creator_id'
        )
        expect(json['creator_id']).to eq(user.id)
      end

      it 'fails gracefully with bad params' do
        post '/v1/challenges',
             headers: auth_headers,
             params: {
               name: '90s Website',
               start: '2018-03-15',
               end: '2018-03-14'
             }

        expect(response.status).to eq(422)
        expect(json['errors']).to include('end')
      end
    end
  end

  describe 'GET /v1/challenges/:id' do
    let!(:challenge) { create(:challenge) }

    it 'successfully returns challenge' do
      get "/v1/challenges/#{challenge.id}"

      expect(response.status).to eq(200)
      expect(json).to include('id' => challenge.id)
    end
  end
end
