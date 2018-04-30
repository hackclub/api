# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::SlackInvites', type: :request, vcr: true do
  describe 'POST /v1/slack_invites' do
    it 'should succeed' do
      post '/v1/slack_invites', params: { email: 'foo@example.com' }
      expect(response.status).to eq(201)
      expect(json['email']).to eq('foo@example.com')
    end

    context 'with a duplicate email' do
      before { create(:slack_invite, email: 'bar@example.com') }

      it 'gracefully fails' do
        post '/v1/slack_invites', params: { email: 'bar@example.com' }
        expect(response.status).to eq(422)
        expect(json['errors']).to include('email')
      end
    end
  end
end
