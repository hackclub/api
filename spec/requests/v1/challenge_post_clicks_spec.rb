# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::ChallengePostClicks', type: :request do
  describe 'GET /v1/posts/:id/redirect' do
    let(:post) { create(:challenge_post) }

    # override in subtests
    let(:headers) { {} }

    before { get "/v1/posts/#{post.id}/redirect", headers: headers }

    it 'redirects to correct url' do
      expect(response.status).to eq(302)
      expect(response.headers['Location']).to eq(post.url)
    end

    it 'creates a ChallengePostClick' do
      click = ChallengePostClick.last

      # required fields are properly set
      expect(click.challenge_post).to eq(post)
      expect(click.ip_address).to eq('127.0.0.1')
    end

    context 'when user agent is set' do
      let(:headers) { { 'User-Agent': 'Test Agent' } }

      it 'properly saves it' do
        expect(ChallengePostClick.last.user_agent).to eq('Test Agent')
      end
    end

    context 'when logged in' do
      let(:user) { create(:user_authed) }
      let(:headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

      it 'properly saves user' do
        expect(ChallengePostClick.last.user).to eq(user)
      end
    end
  end
end
