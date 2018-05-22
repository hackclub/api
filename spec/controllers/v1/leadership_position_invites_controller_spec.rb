# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::LeadershipPositionInvitesController, type: :controller do
  describe 'GET #accept' do
    it 'returns http success' do
      get :accept
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #reject' do
    it 'returns http success' do
      get :reject
      expect(response).to have_http_status(:success)
    end
  end
end
