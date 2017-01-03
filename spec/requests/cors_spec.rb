require 'rails_helper'

describe 'CORS', type: :request do
  origins = ['https://new.hackclub.com', 'https://hackclub.com']

  origins.each do |origin|
    it "returns the response CORS headers for #{origin}" do
      get '/v1/ping', headers: { 'HTTP_ORIGIN' => origin }

      expect(response.headers['Access-Control-Allow-Origin']).to eq(origin)
    end

    it "handles CORS preflights OPTIONS request for #{origin}" do
      options '/v1/ping', headers: {
        'HTTP_ORIGIN' => origin,
        'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET',
        'HTTP_ACCESS_CONTROL_REQUEST_HEADERS' => 'test'
      }

      expect(response.headers['Access-Control-Allow-Origin']).to eq(origin)
      expect(response.headers['Access-Control-Allow-Methods'])
        .to eq('GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD')
      expect(response.headers['Access-Control-Allow-Headers']).to eq('test')
      expect(response.headers).to have_key('Access-Control-Max-Age')
    end
  end
end
