
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::NewClubs::LeadershipPositionInvites', type: :request do
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

    # so emails get sent
    perform_enqueued_jobs do
      send(method, url, params: params, headers: headers)
    end
  end

  describe 'POST /v1/new_clubs/:id/invite_leader' do
    let(:club) { create(:new_club) }

    let(:method) { :post }
    let(:url) { "/v1/new_clubs/#{club.id}/invite_leader" }
    let(:params) do
      {
        email: 'user@example.com'
      }
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires admin or leadership position' do
        expect(response.status).to eq(403)
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'succeeds' do
          expect(response.status).to eq(200)

          expect(LeadershipPositionInvite.last.sender).to eq(user)

          # sends invite email to invitee
          expect(LeadershipPositionInviteMailer.deliveries.length).to eq(1)
        end

        context 'after an invite has already been created for the user' do
          let(:setup) do
            create(
              :leadership_position_invite,
              new_club: club,
              sender: user,
              user: create(:user, email: 'user@example.com')
            )
          end

          it 'gracefully fails' do
            expect(response.status).to eq(422)
          end
        end
      end

      context 'with leadership position' do
        let(:setup) { club.new_leaders << create(:new_leader, user: user) }

        it 'succeeds' do
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
