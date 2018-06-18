# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::NewLeaders', type: :request do
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

  describe 'GET /v1/new_leaders/:id' do
    let(:leader) { create(:new_leader) }

    let(:method) { :get }
    let(:url) { "/v1/new_leaders/#{leader.id}" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      let(:full_fields) do
        %w[
          id
          created_at
          updated_at
          name
          email
          birthday
          expected_graduation
          gender
          ethnicity
          phone_number
          address
          latitude
          longitude
          parsed_address
          parsed_city
          parsed_state
          parsed_state_code
          parsed_postal_code
          parsed_country
          parsed_country_code
          personal_website
          github_url
          linkedin_url
          facebook_url
          twitter_url
        ]
      end

      let(:limited_fields) do
        %w[
          id
          name
        ]
      end

      it 'requires you to have relationship with leader' do
        expect(response.status).to eq(403)
      end

      context 'as co-lead' do
        let(:setup) do
          colead = create(:new_leader, user: user)
          leader.new_clubs << create(:new_club)
          leader.new_clubs.first.new_leaders << colead
        end

        it 'shows basic info' do
          expect(response.status).to eq(200)

          expect(json).to include(*limited_fields)
          expect(json).to_not include(*(full_fields - limited_fields))
        end
      end

      context 'as leader themselves' do
        let(:user) { create(:user_authed, new_leader: leader) }
        let(:headers) { auth_headers }

        it 'shows full info' do
          expect(response.status).to eq(200)
          expect(json).to include(*full_fields)
        end
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'shows full info' do
          expect(response.status).to eq(200)
          expect(json).to include(*full_fields)
        end
      end
    end
  end

  describe 'PATCH /v1/new_leaders/:id' do
    let(:leader) { create(:new_leader) }
    let(:params) do
      {
        name: 'Larry King',
        email: 'larry@king.com',
        birthday: '1940-06-21',
        expected_graduation: '2019-10-10',
        gender: :male,
        ethnicity: :white,
        phone_number: '444-444-4444',
        address: '123 Test Avenue, NYC',
        personal_website: 'https://larry.king',
        github_url: 'https://github.com/larryking',
        linkedin_url: 'https://linkedin.com/u/larryking',
        facebook_url: 'https://facebook.com/larry',
        twitter_url: 'https://twitter.com/larryking'
      }
    end

    let(:method) { :patch }
    let(:url) { "/v1/new_leaders/#{leader.id}" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it "requires you to be the leader's user" do
        expect(response.status).to eq(403)
      end

      context "as leader's user" do
        let(:setup) { leader.update_attributes(user: user) }

        it 'succeeds' do
          expect(response.status).to eq(200)

          expect(json).to include(
            'name' => 'Larry King',
            'email' => 'larry@king.com',
            'birthday' => '1940-06-21',
            'expected_graduation' => '2019-10-10',
            'gender' => 'male',
            'ethnicity' => 'white',
            'phone_number' => '444-444-4444',
            'address' => '123 Test Avenue, NYC',
            'personal_website' => 'https://larry.king',
            'github_url' => 'https://github.com/larryking',
            'linkedin_url' => 'https://linkedin.com/u/larryking',
            'facebook_url' => 'https://facebook.com/larry',
            'twitter_url' => 'https://twitter.com/larryking'
          )
        end

        context 'with invalid params' do
          let(:params) do
            {
              name: nil
            }
          end

          it 'fails gracefully' do
            expect(response.status).to eq(422)
            expect(json['errors']).to include('name')
          end
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
end
