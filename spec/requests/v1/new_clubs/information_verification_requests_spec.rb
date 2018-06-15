# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::NewClubs::InformationVerificationRequests',
               type: :request do

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

  describe 'POST /v1/new_clubs/information_verification_requests/:id/verify' do
    let(:info_req) { create(:new_clubs_information_verification_request) }

    let(:method) { :post }
    let(:url) do
      "/v1/new_clubs/information_verification_requests/#{info_req.id}/verify"
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:headers) { auth_headers }
      let(:user) { create(:user_authed) }

      it 'requires leadership position' do
        expect(response.status).to eq(403)
      end

      context 'as user with leadership position' do
        let(:user) do
          u = create(:user_authed)
          info_req.new_club.new_leaders << create(:new_leader, user: u)

          u
        end

        it 'succeeds' do
          expect(response.status).to eq(200)

          expect(json['verifier_id']).to eq(user.id)
          expect(
            Time.zone.parse(json['verified_at'])
          ).to be_within(1.minute).of(Time.current)
        end

        context 'when already verified' do
          let(:setup) do
            info_req.update(verified_at: Time.current, verifier: user)
          end

          it 'fails gracefully' do
            expect(response.status).to eq(422)
            expect(json['errors']).to include('verified_at')
          end
        end
      end
    end
  end
end
