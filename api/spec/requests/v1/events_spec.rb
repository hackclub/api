# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Events', type: :request do
  describe 'GET /v1/events' do
    before { 5.times { create(:event) } }

    it 'properly lists events' do
      get '/v1/events'
      expect(response.status).to eq(200)

      # returns all events
      expect(json.length).to eq(5)

      # returns proper attributes
      expect(json[0]).to include(
        'id',
        'created_at',
        'updated_at',
        'start',
        'end',
        'name',
        'website',
        'address',
        'latitude',
        'longitude'
      )
    end
  end
end
