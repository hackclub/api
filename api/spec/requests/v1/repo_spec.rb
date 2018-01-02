# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Repo', type: :request do
  describe 'GET /v1/repo' do
    it 'returns a 404 when there is no file' do
      get '/v1/repo/this_file_should_not_exist'

      expect(response).to have_http_status(404)
      expect(response.content_type).to eq('text/plain')
    end

    it 'returns a markdown file' do
      get '/v1/repo/README.md'

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('text/markdown')
    end

    it 'returns a rendered markdown file' do
      get '/v1/repo/README.html'

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('text/html')
    end

    it 'returns an image file' do
      get '/v1/repo/clubs/posters/orpheus2.png'

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('image/png')
    end
  end
end
