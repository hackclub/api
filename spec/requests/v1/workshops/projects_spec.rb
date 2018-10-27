# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Workshops::Projects', type: :request do
  let(:user) { nil } # set in subtests
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  # set these in subtests
  let(:params) { {} }
  let(:headers) { {} }
  let(:method) { :get }
  let(:url) { '' }
  let(:setup) {} # override this to do any setup you'd usually do in before

  before do
    setup
    send(method, url, params: params, headers: headers)
  end

  # TODO!
  describe 'POST /v1/workshops/:workshop_slug/projects'

  describe 'GET /v1/workshops/:workshop_slug/projects' do
    let(:setup) { create_list(:workshop_project, 5, workshop_slug: 'testshop') }

    let(:method) { :get }
    let(:url) { '/v1/workshops/testshop/projects' }

    it 'returns all the submissions for the workshop' do
      expect(json.length).to eq(5)

      # workshop that was created w/o authentication
      expect(json.first).to include(
        'id',
        'created_at',
        'updated_at',
        'live_url',
        'code_url',
        'screenshot'
      )
      expect(json.first['screenshot']).to include(
        'id',
        'created_at',
        'updated_at',
        'type',
        'file_path'
      )
    end
  end
end
