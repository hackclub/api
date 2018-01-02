# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples :cors_origin_tests do |origins|
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

describe 'CORS', type: :request do
  ORIGINS = ['https://new.hackclub.com', 'https://hackclub.com'].freeze

  context 'not in development' do
    include_examples :cors_origin_tests, ORIGINS
  end

  context 'in development' do
    let!(:orig_env) { Rails.env }

    before { Rails.env = 'development' }
    after { Rails.env = orig_env }

    include_examples :cors_origin_tests,
                     ORIGINS + ['localhost', 'http://localhost']
  end
end
