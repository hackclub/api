# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'V1::Clubs', type: :request do
  describe 'GET /v1/clubs' do
    it 'returns an empty array when no clubs exist' do
      get '/v1/clubs'

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(json).to eq([])
    end

    context 'when dead clubs exist' do
      before do
        5.times { create(:dead_club) }
      end

      it 'does not return any clubs' do
        get '/v1/clubs'

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(json).to eq([])
      end
    end

    context 'when multiple alive clubs exist' do
      before do
        5.times { create(:alive_club) }
      end

      it 'returns the correct number of clubs' do
        get '/v1/clubs'

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(json.length).to eq(5)
      end
    end
  end

  describe 'GET /v1/clubs/:id' do
    before { get "/v1/clubs/#{id}" }

    let(:club) { create(:club) }

    context 'with valid id' do
      let(:id) { club.id }

      # We need to serialize the club to JSON and then parse that JSON to make
      # the attributes match what the API will return since JSON doesn't support
      # floating point numbers to the precision that Rails does.
      let(:club_attrs) do
        JSON.parse(club.to_json).except('latitude', 'longitude')
      end

      it 'retrieves the club successfully' do
        expect(response).to have_http_status(200)

        # Make sure all attributes match
        club_attrs.each do |k, v|
          expect(json[k]).to eq(v)
        end
      end
    end

    context 'with invalid id' do
      let(:id) { club.id + 1 }

      it 'receives a 404' do
        expect(response).to have_http_status(404)
        expect(json['error']).to eq('Club not found')
      end
    end
  end
end
