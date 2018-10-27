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

  describe 'POST /v1/workshops/:workshop_slug/projects' do
    let(:method) { :post }
    let(:url) { '/v1/workshops/testshop/projects' }

    it 'fails without params' do
      expect(response.status).to eq(422)
    end

    context 'with proper params' do
      let(:screenshot) { create(:workshop_project_screenshot) }
      let(:params) do
        {
          live_url: 'https://hackclub.com',
          code_url: 'https://github.com/hackclub/site',
          screenshot_id: screenshot.id
        }
      end

      it 'succeeds' do
        expect(response.status).to eq(201)
      end

      context 'when authenticated' do
        let(:user) { create(:user_authed) }
        let(:headers) { auth_headers }

        it 'associates the authenticated user' do
          expect(response.status).to eq(201)
          expect(json['user']['username']).to eq(user.username)
        end
      end
    end
  end

  describe 'GET /v1/workshops/:workshop_slug/projects' do
    let(:setup) do
      create_list(:workshop_project, 4, workshop_slug: 'testshop')
      create(:workshop_project_with_user, workshop_slug: 'testshop')
    end

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

      # workshop created w/ authentication
      expect(json.last).to include('user')
      expect(json.last['user']).to include('username')
    end
  end
end
