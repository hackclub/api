# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Users::NewLeaders', type: :request do
  let(:user) { nil } # set this in subtests
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  # set these in subtests
  let(:params) { {} }
  let(:headers) { {} }
  let(:method) { :get }
  let(:url) { '' }
  let(:setup) {} # override this to do any setup you'd usually do in before

  before do
    setup
    send(method, url, params: params, headers: headers)
  end

  describe 'POST /v1/users/:id/new_leader' do
    let(:user) { create(:user_authed) }
    let(:req_user) { user }

    let(:method) { :post }
    let(:url) { "/v1/users/#{req_user.id}/new_leader" }

    let(:params) do
      {
        "name": 'First Last',
        "email": 'first@example.com',
        "gender": 'male',
        "ethnicity": 'white',
        "phone_number": '+1-333-333-3333',
        "address": 'Test Address, City, ST 99324'
      }
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:headers) { auth_headers }

      it 'succeeds' do
        expect(response.status).to eq(201)
      end

      context 'as user who already has a new_leader' do
        let(:setup) do
          user.new_leader = create(:new_leader)
          user.save
        end

        it 'fails' do
          expect(response.status).to eq(409)
        end
      end

      context 'as admin' do
        let(:req_user) { create(:user) }
        let(:user) { create(:user_admin_authed) }

        it 'succeeds' do
          expect(response.status).to eq(201)
        end
      end
    end
  end
end
