# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserAuth, type: :controller do
  # make fake controller for testing
  controller(V1::ApiController) do
    include UserAuth

    def fake_action
      render_success
    end
  end

  before do
    routes.draw do
      get 'fake_action' => 'v1/api#fake_action'
    end
  end

  let(:user) do
    a = create(:user)
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
    create(:user, auth_token: nil)

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
    request.headers['Authorization'] = "Bearer #{user.auth_token}"

    get :fake_action

    expect(response.status).to eq(200)
    expect(json).to include('success' => true)
  end

  it 'errors when auth token is older than 24 hours' do
    user.auth_token_generation -= 1.day
    user.save

    request.headers['Authorization'] = "Bearer #{user.auth_token}"

    get :fake_action

    expect(response.status).to eq(401)
    expect(json).to include('error' => 'auth token expired')
  end

  context 'when specifying specific methods to authorize' do
    controller(V1::ApiController) do
      USER_AUTH = { only: [:fake_action_1] }.freeze
      include UserAuth

      def fake_action_1
        render_success
      end

      def fake_action_2
        render_success
      end

      # this is really dumb, but for some reason the USER_AUTH constant declared
      # in this block ends up in the toplevel scope, fudging UserAuth's usage in
      # other controllers -- this line undeclares it, ensuring it doesn't mess
      # with other controllers
      Object.send(:remove_const, :USER_AUTH)
    end

    before do
      routes.draw do
        get 'fake_action_1' => 'v1/api#fake_action_1'
        get 'fake_action_2' => 'v1/api#fake_action_2'
      end
    end

    it 'requires auth for fake_action_1' do
      get :fake_action_1
      expect(response.status).to eq(401)
    end

    it 'successfully auths for fake_action_1' do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      get :fake_action_1
      expect(response.status).to eq(200)
    end

    it 'does not require auth for fake_action_2' do
      get :fake_action_2
      expect(response.status).to eq(200)
    end
  end
end
