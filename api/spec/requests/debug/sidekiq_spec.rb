# frozen_string_literal: true

require 'rails_helper'

describe 'Sidekiq dashboard', type: :request do
  before do
    allow(
      Rails.application.secrets
    ).to receive(:sidekiq_http_username).and_return('AzureDiamond')

    allow(
      Rails.application.secrets
    ).to receive(:sidekiq_http_password).and_return('hunter2')
  end

  it 'should fail with no credentials' do
    get '/debug/sidekiq'

    expect(response.status).to eq(401)
  end

  it 'should fail with incorrect credentials' do
    get '/debug/sidekiq', headers: {
      'HTTP_AUTHORIZATION': auth_header('AzureDiamond', 'hunter3')
    }

    expect(response.status).to eq(401)
  end

  it 'should load with the right credentials' do
    get '/debug/sidekiq', headers: {
      'HTTP_AUTHORIZATION': auth_header('AzureDiamond', 'hunter2')
    }

    expect(response.status).to eq(200)
  end

  private

  def auth_header(username, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(
      username,
      password
    )
  end
end
