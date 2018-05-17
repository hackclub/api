# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::NewLeaders::NewClubs' do
  describe 'GET /v1/new_leaders/:id/new_clubs' do
    let(:auth_headers) { { 'Authorization': "Bearer #{auth_token}" } }
    let(:auth_token) { user.auth_token } # make sure to set user

    let(:user) { create(:user_authed) }
    let(:leader) { create(:new_leader, user: user) }

    let(:headers) { {} } # override this!

    before do
      3.times { leader.new_clubs << create(:new_club) }

      get "/v1/new_leaders/#{leader.id}/new_clubs", headers: headers
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:headers) { auth_headers }

      it 'lists associated clubs' do
        expect(response.status).to eq(200)

        expect(json.length).to eq(3)

        # list all leadership positions
        expect(json[0]).to include('leadership_positions')

        # ensure all proper data is included here
        expect(json[0]['leadership_positions']).to include(
          'id',
          'created_at',
          'updated_at',
          'new_leader_id'
        )
      end

      context 'as a different user' do
        let(:user2) { create(:user_authed) }
        let(:auth_token) { user2.auth_token }

        it 'is unauthorized' do
          expect(response.status).to eq(403)
        end
      end

      context 'as admin' do
        let(:admin) { create(:user_admin_authed) }
        let(:auth_token) { admin.auth_token }

        it 'succeeds' do
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
