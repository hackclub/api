# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::WorkshopProjectClick', type: :request do
  describe 'GET /v1/projects/:id/redirect/:type_of' do
    let(:project) { create(:workshop_project) }

    # override in subtests
    let(:headers) { {} }

    let(:redirect_type) { 'code' }
    let(:expected_url) { project.code_url }

    before do |example|
      unless example.metadata[:skip_before]
        get "/v1/projects/#{project.id}/redirect/#{redirect_type}",
            headers: headers
      end
    end

    it 'redirects to correct url' do
      expect(response.status).to eq(302)
      expect(response.headers['Location']).to eq(expected_url)
    end

    it 'creates a WorkshopProjectClick' do
      click = WorkshopProjectClick.last

      expect(click.workshop_project).to eq(project)
      expect(click.ip_address).to eq('127.0.0.1')
      expect(click.type_of).to eq(redirect_type)
    end

    context 'when user agent is set' do
      let(:headers) { { 'User-Agent': 'Test Agent' } }

      it 'properly saves it' do
        expect(WorkshopProjectClick.last.user_agent).to eq('Test Agent')
      end
    end

    context 'when requesting live url' do
      let(:redirect_type) { 'live' }
      let(:expected_url) { project.live_url }

      it 'properly saves click type' do
        expect(WorkshopProjectClick.last.type_of).to eq('live')
      end
    end

    context 'when logged in' do
      let(:user) { create(:user_authed) }
      let(:headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

      it 'properly saves user' do
        expect(WorkshopProjectClick.last.user).to eq(user)
      end
    end

    context 'when requesting invalid url type' do
      let(:redirect_type) { 'foobar' }

      it 'raises an error', :skip_before do
        expect do
          get "/v1/projects/#{project.id}/redirect/#{redirect_type}",
              headers: headers
        end.to raise_error(ArgumentError)
      end
    end
  end
end
