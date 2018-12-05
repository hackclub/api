# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::WorkshopProjectClick', type: :request do
  describe 'GET /v1/projects/:id/redirect/:type_of' do
    let(:project) { create(:workshop_project) }

    # override in subtests
    let(:headers) { {} }

    before { get "/v1/projects/#{project.id}/redirect/live", headers: headers }

    it 'redirects to correct url' do
      expect(response.status).to eq(302)
      expect(response.headers['Location']).to eq(post.live_url)
    end

    it 'creates a WorkshopProjectClick' do
      click = WorkshopProjectClick.last

      # idk
      expect(click.workshop_project).to eq(project)
      expect(click.ip_address).to eq('127.0.0.1')
      expect(click.type_of).to eq('live')
    end

    context 'when user agent is set' do
      let(:headers) { { 'User-Agent': 'Test Agent' } }

      it 'properly saves it' do
        expect(WorkshopProjectClick.last.user_agent).to eq('Test Agent')
      end
    end

    context 'when logged in' do
      let(:user) { create(:user_authed) }
      let(:headers) { { 'Authorizeation': "Bearer #{user.auth_token}" } }

      it 'properly saves user' do
        expect(WorkshopProjectClick.last.user).to eq(user)
      end
    end
  end
end
