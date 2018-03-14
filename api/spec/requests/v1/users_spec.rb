# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  describe 'POST /v1/users/auth' do
    it 'fails with an invalid email' do
      post '/v1/users/auth', params: { email: 'bad_email' }

      expect(response.status).to eq(422)
      expect(json['errors']).to include('email')
    end

    it 'creates new object and sends email with new and valid email' do
      # ensure any jobs are ran during request
      perform_enqueued_jobs do
        post '/v1/users/auth', params: { email: 'foo@bar.com' }
      end

      expect(response.status).to eq(200)

      # return created object
      expect(json).to include('email' => 'foo@bar.com')
      expect(json).to include('id')

      # do not return fields that give away information
      expect(json).to_not include('created_at')
      expect(json).to_not include('updated_at')

      # but not secret fields
      expect(json).to_not include('auth_token')

      # creates user object w/ generated login code
      user = User.last
      expect(user.email).to eq('foo@bar.com')
      expect(user.login_code).to match(/\d{6}/)

      # email queued to be sent
      expect(ApplicantMailer.deliveries.length).to be(1)
    end

    it 'does not create object but sends login code with existing email' do
      # init user
      user = create(:user)
      user.generate_login_code!
      user.save

      perform_enqueued_jobs do
        post '/v1/users/auth', params: { email: user.email }
      end

      expect(response.status).to eq(200)

      # returns existing object
      expect(json).to include('email' => user.email)
      expect(json).to include('id' => user.id)

      # generates new login code
      expect(user.login_code).to_not eq(user.reload.login_code)

      # queued email
      expect(ApplicantMailer.deliveries.length).to be(1)
    end

    it "doesn't care about case when emails already exist" do
      u = create(:user, email: 'foo@bar.com')

      post '/v1/users/auth', params: { email: 'Foo@bar.com' }

      expect(response.status).to eq(200)

      # returns existing user
      expect(json).to include('id' => u.id)
    end
  end

  describe 'POST /v1/users/:id/exchange_login_code' do
    let(:user) do
      a = create(:user)
      a.generate_login_code!
      a.save

      a
    end

    it 'returns auth token with valid login code' do
      post "/v1/users/#{user.id}/exchange_login_code",
           params: { login_code: user.login_code }

      expect(response.status).to eq(200)

      expect(json).to include('auth_token')
    end

    it 'return error with no login code' do
      post "/v1/users/#{user.id}/exchange_login_code"

      expect(response.status).to eq(401)
      expect(json['errors']).to include('login_code')
    end

    it 'returns error with invalid login code' do
      post "/v1/users/#{user.id}/exchange_login_code",
           params: { login_code: '000111' }

      expect(response.status).to eq(401)
      expect(json['errors']).to include('login_code')
    end

    it 'fails when valid login code is used twice' do
      # 1st time..
      post "/v1/users/#{user.id}/exchange_login_code",
           params: { login_code: user.login_code }

      # 2nd time...
      post "/v1/users/#{user.id}/exchange_login_code",
           params: { login_code: user.login_code }

      expect(response.status).to eq(401)
      expect(json['errors']).to include('login_code')
    end

    it 'does not allow login codes older than 15 minutes' do
      user.login_code_generation -= 15.minutes
      user.save

      post "/v1/users/#{user.id}/exchange_login_code",
           params: { login_code: user.login_code }

      expect(response.status).to eq(401)
      expect(json['errors']).to include('login_code')
    end

    it 'does not allow login codes for other users' do
      other_user = create(:user)
      other_user.generate_login_code!
      other_user.save

      post "/v1/users/#{user.id}/exchange_login_code",
           params: { login_code: other_user.login_code }

      expect(response.status).to eq(401)
      expect(json['errors']).to include('login_code')
    end

    it '404s when user id does not exist' do
      post "/v1/users/#{user.id + 1}/exchange_login_code",
           params: { login_code: user.login_code }

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
    end
  end

  describe 'GET /v1/users/current' do
    it 'returns 401' do
      get '/v1/users/current'

      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }

      it 'returns the current user' do
        get '/v1/users/current', headers: {
          'Authorization': "Bearer #{user.auth_token}"
        }

        expect(response.status).to eq(200)
        expect(json).to include('created_at', 'updated_at', 'email', 'admin_at')
        expect(json).to_not include(
          'login_code', 'login_code_generation',
          'auth_token', 'auth_token_generation'
        )
      end
    end
  end
end
