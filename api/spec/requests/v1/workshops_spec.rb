require 'rails_helper'

RSpec.describe 'V1::Workshops', type: :request do
  describe 'GET /v1/workshops' do
    it 'returns a 404 when there is no file' do
      get '/v1/workshops/this_file_should_not_exist'

      expect(response).to have_http_status(404)
      expect(response.content_type).to eq('text/html')
    end

    it 'returns a rendered markdown file successfully' do
      get '/v1/workshops/README.md'

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('text/html')
    end

    it 'returns an image file correctly' do
      get '/v1/workshops/workshops/dawgshop/img/tupac.gif'

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('image/gif')
    end
  end
end
