# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::AthulClubs', type: :request do
  let(:auth_token) { Rails.application.secrets.athul_auth_token }
  let(:club_attrs) { attributes_for(:club) }
  let(:leader_attrs) { attributes_for(:leader_with_address) }
  let(:fields) do
    {
      auth_token: auth_token,
      club: {
        name: club_attrs[:name],
        address: club_attrs[:address]
      },
      leader: {
        name: leader_attrs[:name],
        email: leader_attrs[:email],
        gender: leader_attrs[:gender],
        year: leader_attrs[:year],
        phone_number: leader_attrs[:phone_number],
        github_username: leader_attrs[:github_username],
        twitter_username: leader_attrs[:twitter_username],
        address: leader_attrs[:address]
      }
    }
  end

  describe 'POST /v1/athul_clubs' do
    include HackbotTeamSetup

    it 'fails without auth token' do
      fields[:auth_token] = nil

      post '/v1/athul_clubs', params: fields

      # TODO: this should actually return 422 and return in the regular field
      # errors format
      expect(response.status).to eq(401)
      expect(
        json['errors']['base']
      ).to include('missing / invalid authentication')
    end

    it 'fails with invalid auth token' do
      fields[:auth_token] = 'invalid_token'

      post '/v1/athul_clubs', params: fields

      expect(response.status).to eq(401)
      expect(
        json['errors']['base']
      ).to include('missing / invalid authentication')
    end

    it 'fails when not all required leader fields are set' do
      fields[:leader][:name] = nil

      post '/v1/athul_clubs', params: fields

      expect(response.status).to eq(422)
      expect(json['errors']['leader.name']).to include("can't be blank")
    end

    it 'fails when not all required club fields are set' do
      fields[:club][:name] = nil

      post '/v1/athul_clubs', params: fields

      expect(response.status).to eq(422)
      expect(json['errors']['club.name']).to include("can't be blank")
    end

    it 'succeeds when all required fields are set' do
      # set email to something that exists on slack for the email -> slack id
      # resolution
      user = SlackClient::Users.gen_user
      fields[:leader][:email] = user[:profile][:email]

      post '/v1/athul_clubs', params: fields

      expect(response.status).to eq(201)

      # ensure all fields were properly set
      expect(json['club']).to include(fields[:club].stringify_keys)
      expect(json['leader']).to include(fields[:leader].stringify_keys)

      # ensure slack id was set on leader
      expect(json['leader']['slack_id']).to_not be_nil

      # ensures that relationships were set up correctly
      created = AthulClub.last
      expect(created.club.leaders).to include(created.leader)

      # and that the letter was created
      expect(created.letter).to_not be_nil

      # reset SlackClient
      SlackClient::Users.reset
    end

    it 'fails when email cannot be found on slack', vcr: true do
      fields[:leader][:email] = 'notarealemail@fake.com'

      post '/v1/athul_clubs', params: fields

      expect(response.status).to_not eq(201)
    end
  end
end
