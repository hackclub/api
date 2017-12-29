require 'rails_helper'

RSpec.describe ApplicantAuth, type: :controller do
  # make fake controller for testing
  controller(ActionController::Base) do
    include ApplicantAuth

    def fake_action
      render json: { success: true }, status: 200
    end
  end

  before do
    routes.draw do
      get 'fake_action' => 'anonymous#fake_action'
    end
  end

  let(:applicant) do
    a = create(:applicant)
    a.generate_auth_token!
    a.save

    a
  end

  it 'errors when auth header is not present' do
    get :fake_action

    expect(response.status).to eq(401)
    expect(json).to include('error' => 'authorization required')
  end

  it 'errors when auth token is nil' do
    # create applicant with nil auth token to try and trick it
    create(:applicant, auth_token: nil)

    request.headers['Authorization'] = 'Bearer'

    get :fake_action

    expect(response.status).to eq(401)
    expect(json).to include('error' => 'authorization invalid')
  end

  it 'errors when auth token is incorrect' do
    request.headers['Authorization'] = 'Bearer notarealtoken'

    get :fake_action

    expect(response.status).to eq(401)
    expect(json).to include('error' => 'authorization invalid')
  end

  it 'succeeds with valid auth token' do
    request.headers['Authorization'] = "Bearer #{applicant.auth_token}"

    get :fake_action

    expect(response.status).to eq(200)
    expect(json).to include('success' => true)
  end

  it 'errors when auth token is older than 24 hours' do
    applicant.auth_token_generation -= 1.day
    applicant.save

    request.headers['Authorization'] = "Bearer #{applicant.auth_token}"

    get :fake_action

    expect(response.status).to eq(401)
    expect(json).to include('error' => 'auth token expired')
  end
end
