require 'rails_helper'

RSpec.describe 'V1::Pings', type: :request do
  describe 'GET /v1/ping' do
    it 'returns pong' do
      get '/v1/ping'

      json = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(json['result']).to eq('pong')
    end
  end
end
