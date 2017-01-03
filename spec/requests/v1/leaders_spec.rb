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
        slack_username: 'foo_bar',
        github_username: 'foo_bar',
        twitter_username: 'foobar',
        address: '4242 Fake St, Some City, CA 90210',
        club_id: club.id
      }
    end

    context 'with valid attributes' do
      let!(:starting_letter_count) { Letter.count }

      before { post '/v1/leaders/intake', params: req_body }

      it 'creates the leader' do
        expect(response.status).to eq(201)

        # Check to make sure expected attributes are set
        #
        # We don't check for club_id because leaders can have multiple clubs and
        # the intake form doesn't support creating a leader with multiple clubs.
        req_body.except(:club_id).each do |k, v|
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

      it 'creates a letter for the leader' do
        expect(Letter.count).to eq(starting_letter_count + 1)
        expect(Letter.last.name).to eq(req_body[:name])
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
