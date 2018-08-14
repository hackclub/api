# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Utilities', type: :request do
  describe 'POST /v1/utilities/new_leader_exists' do
    it 'returns false' do
      post '/v1/utilities/new_leader_exists',
           params: { email: 'sample@email.com' }

      expect(response.status).to eq(200)
      expect(json).to include('exists' => false)
    end

    context 'when email is taken' do
      before { create(:new_leader, email: 'sample@email.com') }

      it 'returns true' do
        post '/v1/utilities/new_leader_exists',
             params: { email: 'sample@email.com' }

        expect(response.status).to eq(200)
        expect(json).to include('exists' => true)
      end
    end
  end
end
