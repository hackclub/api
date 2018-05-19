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
        post '/v1/users/auth', params: {
          email: 'foo@bar.com'
        }
      end

      expect(response.status).to eq(200)

      # returns success message & user id
      expect(json['id']).to eq(User.last.id)
      expect(json['status']).to eq('login code sent')

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
      expect(json['status']).to eq('login code sent')

      # generates new login code
      expect(user.login_code).to_not eq(user.reload.login_code)

      # queued email
      expect(ApplicantMailer.deliveries.length).to be(1)
    end

    it "doesn't care about case when emails already exist" do
      create(:user, email: 'foo@bar.com')

      post '/v1/users/auth', params: { email: 'Foo@bar.com' }

      expect(response.status).to eq(200)

      # returns success
      expect(json['status']).to eq('login code sent')
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
        expect(json).to include(
          'created_at',
          'updated_at',
          'email',
          'username',
          'admin_at',
          'email_on_new_challenges',
          'email_on_new_challenge_posts',
          'email_on_new_challenge_post_comments',
          'new_leader'
        )
        expect(json).to_not include(
          'login_code', 'login_code_generation',
          'auth_token', 'auth_token_generation'
        )
      end

      context 'with associated leader' do
        before { create(:new_leader, user: user) }

        it 'includes leader fields' do
          get '/v1/users/current', headers: {
            'Authorization': "Bearer #{user.auth_token}"
          }

          expect(response.status).to eq(200)

          # includes new_leader fields
          expect(json['new_leader']).to include(
            'id',
            'created_at',
            'updated_at',
            'name'
            # ... and so on
          )
        end
      end
    end
  end

  describe 'GET /v1/users/:id' do
    let(:user) { create(:user) }
    let(:headers) { {} } # override this

    before { get "/v1/users/#{user.id}", headers: headers }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authed' do
      let(:authed_user) { nil } # override this
      let(:headers) { { 'Authorization': "Bearer #{authed_user.auth_token}" } }

      context 'as non-admin' do
        let(:authed_user) { create(:user_authed) }

        it 'fails' do
          expect(response.status).to eq(403)
        end
      end

      context 'as admin' do
        let(:authed_user) { create(:user_admin_authed) }

        it 'returns all expected user info' do
          expect(response.status).to eq(200)
          expect(json).to include('id', 'created_at', 'updated_at', 'email')
          expect(json).to_not include(
            'auth_token', 'auth_token_generation',
            'login_code', 'login_code_generation'
          )
        end
      end
    end
  end

  describe 'PATCH /v1/users/:id' do
    let(:user) { create(:user_authed) }

    # override in subtests
    let(:headers) { {} }
    let(:params) do
      {
        email: 'shouldntupdate@example.com',
        username: 'newusername',
        email_on_new_challenges: true,
        email_on_new_challenge_posts: true,
        email_on_new_challenge_post_comments: false
      }
    end

    before do
      patch "/v1/users/#{user.id}",
            headers: headers,
            params: params
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:authed_user) { {} } # override in subtest
      let(:headers) { { 'Authorization': "Bearer #{authed_user.auth_token}" } }

      context 'as different user' do
        let(:authed_user) { create(:user_authed) }

        it 'is unauthorized' do
          expect(response.status).to eq(403)
        end
      end

      context 'as same user' do
        let(:authed_user) { user }

        it 'updates appropriate fields' do
          expect(response.status).to eq(200)

          expect(json).to include(
            'email' => user.email,
            'username' => 'newusername',
            'email_on_new_challenges' => true,
            'email_on_new_challenge_posts' => true,
            'email_on_new_challenge_post_comments' => false
          )
        end

        context 'with invalid params' do
          let(:params) do
            {
              username: 'CapitalUsername'
            }
          end

          it 'gracefully fails' do
            expect(response.status).to eq(422)

            expect(json['errors']).to include('username')
          end
        end
      end
    end
  end
end
