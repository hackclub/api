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

  # Okay, so this is a little janky. Creating a club leader automatically does a
  # lookup to try to resolve their given email to a Slack username.
  #
  # This will fail unless a Hackbot::Team is in the database with the default
  # Slack team ID, since that's where it gets its access token from.
  #
  # If you change any of the below tests that have VCR on them, you need to
  # change bot_access_token to a real access token for a bot in the HQ Slack for
  # the responses to be properly re-recorded.
  #
  # Our whole interaction with Slack's API is going to need to be rethought if
  # we're going to have clean automatic tests for methods that use it.
  before do
    team_id = Rails.application.secrets.default_slack_team_id

    Hackbot::Team.create(
      team_id: team_id,
      team_name: 'Default Team',
      bot_user_id: 'U3M0Q1CJ3',
      bot_username: 'orpheus',
      bot_access_token: 'xoxb-123024046615-QaIkc7JGV53chX4WEFb4jlKU'
    )
  end

  describe 'POST /v1/athul_clubs' do
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

    it 'succeeds when all required fields are set', vcr: true do
      # set email to something that exists on slack for the email -> slack id
      # resolution
      fields[:leader][:email] = 'zach@hackclub.com'

      post '/v1/athul_clubs', params: fields

      expect(response.status).to eq(201)
    end

    it 'fails when email cannot be found on slack', vcr: true do
      fields[:leader][:email] = 'notarealemail@fake.com'

      post '/v1/athul_clubs', params: fields

      expect(response.status).to_not eq(201)
    end
  end
end
