# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::ChallengePostUpvote', type: :request do
  let(:user) { create(:user_authed) }
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  let(:cpost) { create(:challenge_post) }

  describe 'POST /v1/posts/:id/upvotes' do
    it 'requires authentication' do
      post "/v1/posts/#{cpost.id}/upvotes"
      expect(response.status).to eq(401)
    end

    it 'succeeds' do
      post "/v1/posts/#{cpost.id}/upvotes", headers: auth_headers
      expect(response.status).to eq(201)
    end
  end

  describe 'DELETE /v1/upvotes/:id' do
    let(:upvote) { create(:challenge_post_upvote, user: user) }

    it 'requires authentication' do
      delete "/v1/upvotes/#{upvote.id}"
      expect(response.status).to eq(401)
    end

    it 'fails if not the upvote creator' do
      upvote = create(:challenge_post_upvote)
      delete "/v1/upvotes/#{upvote.id}", headers: auth_headers
      expect(response.status).to eq(403)
    end

    it 'succeeds when all is good' do
      delete "/v1/upvotes/#{upvote.id}", headers: auth_headers
      expect(response.status).to eq(200)

      # return post fields
      expect(json).to include(
        'id',
        'created_at',
        'user_id',
        'challenge_post_id'
      )
    end
  end
end
