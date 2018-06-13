# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::LeadershipPositions', type: :request do
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

  # this endpoint is currently only used for undeleting leadership_positions
  # through setting deleted_at to nil
  describe 'PATCH /v1/leadership_positions/:id' do
    let(:position) do
      position = create(:leadership_position)
      position.destroy

      position
    end

    let(:method) { :patch }
    let(:url) { "/v1/leadership_positions/#{position.id}" }

    let(:params) do
      {
        deleted_at: nil
      }
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires you to be associated with the club' do
        expect(response.status).to eq(403)
      end

      context 'when associated with the current club' do
        let(:setup) do
          user.update(new_leader: create(:new_leader))
          position.new_club.new_leaders << user.new_leader
        end

        it 'successfully undeletes' do
          expect(response.status).to eq(200)

          expect(json).to include('id' => position.id)
          expect(LeadershipPosition.find_by(id: position.id)).to_not be_nil
        end
      end

      context 'when associated through the deleted position' do
        let(:setup) { position.new_leader.update_attributes(user: user) }

        it 'gracefully fails' do
          expect(response.status).to eq(403)
        end
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'successfully undeletes' do
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'DELETE /v1/leadership_positions/:id' do
    let(:position) { create(:leadership_position) }

    let(:method) { :delete }
    let(:url) { "/v1/leadership_positions/#{position.id}" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires you to be associated with the club' do
        expect(response.status).to eq(403)
      end

      context 'when associated with the club' do
        let(:setup) { position.new_leader.update_attributes(user: user) }

        it 'successfully deletes' do
          expect(response.status).to eq(200)
          expect(json['id']).to eq(position.id)

          expect(LeadershipPosition.find_by(id: position.id)).to be_nil
        end
      end

      context "when associated, but deleting someone else's position" do
        let(:setup) do
          # associated authed user with club by creating new leadership position
          p2 = create(:leadership_position, new_club: position.new_club)
          p2.new_leader.update_attributes(user: user)

          # we'll attempt to delete the original leadership position
        end

        it 'successfully deletes' do
          expect(response.status).to eq(200)
        end
      end

      context 'when admin' do
        let(:user) { create(:user_admin_authed) }

        it 'successfully deletes' do
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
