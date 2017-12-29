# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'V1::Leaders', type: :request do
  describe 'POST /v1/leaders/intake' do
    let(:club) { create(:club) }
    let(:req_body) do
      {
        name: 'Foo Bar',
        email: 'foo@bar.com',
        gender: 'Other',
        year: '2016',
        phone_number: '444-444-4444',
        github_username: 'foo_bar',
        twitter_username: 'foobar',
        address: '4242 Fake St, Some City, CA 90210',
        club_id: club.id
      }
    end

    let(:mock_users) do
      {
        members: [
          {
            profile: {
              email: 'foo@bar.com',
              id: 'foo_bar'
            }
          }
        ]
      }
    end

    let(:team) do
      instance_double(Hackbot::Team)
    end

    let(:cteam) do
      class_double(Hackbot::Team).as_stubbed_const
    end

    let(:users) do
      class_double(SlackClient::Users).as_stubbed_const
    end

    before do
      allow(team).to receive(:bot_access_token)
      allow(cteam).to receive(:find_by).with(
        team_id: Rails.application.secrets.default_slack_team_id
      ).and_return(team)
      allow(users).to receive(:list).with(nil).and_return(mock_users)
    end

    context 'with valid attributes' do
      let(:welcome) do
        class_double(Hackbot::Interactions::Welcome).as_stubbed_const
      end

      before do
        # Mock the leader welcome interaction so we're not trying to send a
        # Slack message every time the test is run.
        allow(welcome).to receive(:trigger)

        post '/v1/leaders/intake', params: req_body
      end

      it 'creates the leader' do
        expect(response.status).to eq(201)

        # Check to make sure expected attributes are set
        #
        # We don't check for club_id because leaders can have multiple clubs and
        # the intake form doesn't support creating a leader with multiple clubs.

        req_body.except(:club_id, :slack_id).each do |k, v|
          expect(json[k.to_s]).to eq(v)
        end
      end

      it 'geocodes the address' do
        # These are really decimals, but encoded are as strings in JSON to
        # preserve accuracy.
        expect(json['latitude']).to be_a String
        expect(json['longitude']).to be_a String
      end

      it 'adds the leader to the given club' do
        # Gotta do this to get the parsed JSON representation of the club
        club_json = JSON.parse(club.to_json)

        expect(json['clubs']).to eq([club_json])
      end
    end

    it "doesn't create the leader with invalid attributes" do
      post '/v1/leaders/intake', params: req_body.except(:name)

      expect(response.status).to eq(422)
      expect(json['errors']['name']).to eq(["can't be blank"])
    end

    it "doesn't create the leader without a club_id" do
      req_body.delete(:club_id)
      post '/v1/leaders/intake', params: req_body

      expect(response.status).to eq(422)
      expect(json['errors']['club_id']).to eq(["can't be blank"])
    end
  end
end
