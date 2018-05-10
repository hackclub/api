# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Attachments', type: :request do
  describe 'POST /v1/attachments' do
    it 'succeeds with correct params' do
      post '/v1/attachments', params: {
        file: Rack::Test::UploadedFile.new(
          test_files.join('event_logo.png'),
          'image/png'
        ),
        type: 'event_logo'
      }

      expect(response.status).to eq(201)
      expect(json).to include(
        'id',
        'created_at',
        'updated_at',
        'file_path',
        'type' => 'event_logo'
      )

      # check to see if path ends w/ filename as a proxy for actually ensuring
      # the path is to the upload
      expect(json['file_path'].split('/').last).to eq('event_logo.png')
    end

    it 'gracefully fails with bad uploads' do
      post '/v1/attachments', params: {
        file: Rack::Test::UploadedFile.new(
          test_files.join('poem.txt'),
          'text/plain'
        ),
        type: 'event_logo'
      }

      expect(response.status).to eq(422)
      expect(json['errors']['file']).to include('must be an image')
    end

    it 'gracefully fails with invalid types' do
      post '/v1/attachments', params: {
        file: Rack::Test::UploadedFile.new(
          test_files.join('event_logo.png'),
          'image/png'
        ),
        type: 'something_that_doesnt_exist'
      }

      expect(response.status).to eq(422)
      expect(json['errors']['type']).to include('unknown type')
    end
  end
end
