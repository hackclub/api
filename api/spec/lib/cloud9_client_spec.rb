# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Cloud9Client, vcr: true do
  let(:team) { 'hackclub' }

  context 'without username' do
    before { Cloud9Client.username = nil }
    after { Cloud9Client.username = Rails.application.secrets.cloud9_username }

    it 'throws an AuthenticationError' do
      expect do
        Cloud9Client::Team.members(team)
      end.to raise_error(AuthenticationError)
    end
  end

  context 'without password' do
    before { Cloud9Client.password = nil }
    after { Cloud9Client.password = Rails.application.secrets.cloud9_password }

    it 'throws an AuthenticationError' do
      expect do
        Cloud9Client::Team.members(team)
      end.to raise_error(AuthenticationError)
    end
  end
end
