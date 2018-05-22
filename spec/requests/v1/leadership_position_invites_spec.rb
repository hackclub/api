# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::LeadershipPositionInvites', type: :request do
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

  let(:invite) { create(:leadership_position_invite) }

  describe 'GET /v1/leadership_position_invites/:id' do
    let(:method) { :get }
    let(:url) { "/v1/leadership_position_invites/#{invite.id}" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'fails due to not being associated' do
        expect(response.status).to eq(403)
      end

      context 'as someone associated with the club' do
        let(:setup) do
          user.update(new_leader: create(:new_leader))
          invite.new_club.new_leaders << user.new_leader
        end

        it 'succeeds' do
          expect(response.status).to eq(200)

          # check inclusion of all expected fields
          expect(json).to include(
            'id',
            'created_at',
            'updated_at',
            'sender',
            'new_club',
            'user_id',
            'accepted_at',
            'rejected_at'
          )

          expect(json['sender']).to include(
            'id',
            'email',
            'username'
          )

          expect(json['new_club']).to include(
            'id',
            'high_school_name'
          )
        end
      end

      context 'as the invitee' do
        let(:setup) { invite.update(user: user) }

        it 'succeeds' do
          expect(response.status).to eq(200)
        end
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'succeeds' do
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'POST /v1/leadership_position_invites/:id/accept' do
    let(:method) { :post }
    let(:url) { "/v1/leadership_position_invites/#{invite.id}/accept" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'fails due to not being invited user' do
        expect(response.status).to eq(403)
      end

      context 'as invited user' do
        let(:setup) { invite.update(user: user) }

        it 'fails due to lack of associated new_leader' do
          expect(response.status).to eq(422)
        end

        context 'with associated new_leader' do
          let(:setup) do
            user.update(new_leader: create(:new_leader))
            invite.update(user: user)
          end

          it 'succeeds' do
            expect(response.status).to eq(200)
            expect(invite.new_club.new_leaders).to include(user.new_leader)
            expect(json['accepted_at']).to_not be_nil
          end

          context 'and an already rejected invite' do
            let(:setup) do
              user.update(new_leader: create(:new_leader))
              invite.update(user: user)
              invite.update(rejected_at: Time.current)
            end

            it 'gracefully fails' do
              expect(response.status).to eq(422)
            end
          end
        end
      end
    end
  end

  describe 'POST /v1/leadership_position_invites/:id/reject' do
    let(:method) { :post }
    let(:url) { "/v1/leadership_position_invites/#{invite.id}/reject" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'fails due to not being the invited user' do
        expect(response.status).to eq(403)
      end

      context 'as invited user' do
        let(:setup) { invite.update(user: user) }

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(json['rejected_at']).to_not be_nil
        end

        context 'and an already accepted invite' do
          let(:setup) do
            invite.update(user: user)
            invite.update(rejected_at: Time.current)
          end

          it 'gracefully fails' do
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end
end
