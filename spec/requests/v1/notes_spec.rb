# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Notes', type: :request do
  let(:user) { create(:user_admin_authed) }
  let(:auth_headers) { { Authorization: "Bearer #{user.auth_token}" } }

  describe 'GET /v1/new_club_applications/:id/notes' do
    let(:application) { create(:new_club_application) }

    before do
      3.times { application.notes.create(user: user, body: 'Test note') }
    end

    it 'requires authentication' do
      get "/v1/new_club_applications/#{application.id}/notes"
      expect(response.status).to eq(401)
    end

    it 'fails if not admin' do
      user.remove_admin!
      user.save

      get "/v1/new_club_applications/#{application.id}/notes",
          headers: auth_headers

      expect(response.status).to eq(403)
    end

    it 'lists all notes' do
      get "/v1/new_club_applications/#{application.id}/notes",
          headers: auth_headers

      expect(response.status).to eq(200)
      expect(json.length).to eq(3)
    end
  end

  describe 'GET /v1/new_clubs/:id/notes' do
    let(:club) { create(:new_club) }

    let(:headers) { {} } # override in subtests

    before do
      3.times { club.notes.create(user: user, body: 'Test note') }

      get "/v1/new_clubs/#{club.id}/notes", headers: headers
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when logged in' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'fails due to lack of permissions' do
        expect(response.status).to eq(403)
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(json.length).to eq(3)
        end
      end
    end
  end

  describe 'POST /v1/new_club_applications/:id/notes' do
    let(:application) { create(:new_club_application) }

    it 'requires authentication' do
      post "/v1/new_club_applications/#{application.id}/notes"
      expect(response.status).to eq(401)
    end

    it 'fails if not admin' do
      user.remove_admin!
      user.save

      post "/v1/new_club_applications/#{application.id}/notes",
           headers: auth_headers,
           params: { body: 'test' }

      expect(response.status).to eq(403)
    end

    it 'succeeds' do
      post "/v1/new_club_applications/#{application.id}/notes",
           headers: auth_headers,
           params: { body: 'test' }

      expect(response.status).to eq(201)
      expect(json).to include(
        'user_id' => user.id,
        'body' => 'test'
      )
    end

    it 'fails with validation errors' do
      post "/v1/new_club_applications/#{application.id}/notes",
           headers: auth_headers,
           params: { body: nil }

      expect(response.status).to eq(422)
      expect(json['errors']).to include('body')
    end
  end

  describe 'POST /v1/new_clubs/:id/notes' do
    let(:club) { create(:new_club) }

    # override in subtests
    let(:headers) { {} }
    let(:params) { {} }

    before do
      post "/v1/new_clubs/#{club.id}/notes",
           headers: headers,
           params: params
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when logged in' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'fails due to lack of authorization' do
        expect(response.status).to eq(403)
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'fails due to invalid params' do
          expect(response.status).to eq(422)
        end

        context 'with valid params' do
          let(:params) { { body: 'Test note' } }

          it 'creates a new note' do
            expect(response.status).to eq(201)
            expect(json['body']).to eq('Test note')
          end
        end
      end
    end
  end

  describe 'GET /v1/notes/:id' do
    let(:note) { create(:note, user: user) }

    it 'requires authentication' do
      get "/v1/notes/#{note.id}"
      expect(response.status).to eq(401)
    end

    it 'fails if not admin' do
      user.remove_admin!
      user.save

      get "/v1/notes/#{note.id}", headers: auth_headers
      expect(response.status).to eq(403)
    end

    it 'succeeds' do
      get "/v1/notes/#{note.id}", headers: auth_headers
      expect(response.status).to eq(200)
      expect(json).to include('body')
    end
  end

  describe 'PATCH /v1/notes/:id' do
    let(:note) { create(:note, user: user) }

    it 'requires authentication' do
      patch "/v1/notes/#{note.id}", params: { body: 'foo' }
      expect(response.status).to eq(401)
    end

    it 'fails if not admin' do
      user.remove_admin!
      user.save

      patch "/v1/notes/#{note.id}",
            headers: auth_headers,
            params: { body: 'foo' }

      expect(response.status).to eq(403)
    end

    it 'fails if not note owner' do
      other_note = create(:note)

      patch "/v1/notes/#{other_note.id}",
            headers: auth_headers,
            params: { body: 'foo' }

      expect(response.status).to eq(403)
    end

    it 'successfully edits' do
      patch "/v1/notes/#{note.id}",
            headers: auth_headers,
            params: { body: 'foo' }

      expect(response.status).to eq(200)
      expect(json).to include('body' => 'foo')
    end

    it 'shows validation errors' do
      patch "/v1/notes/#{note.id}",
            headers: auth_headers,
            params: { body: nil }

      expect(response.status).to eq(422)
      expect(json['errors']).to include('body')
    end
  end

  describe 'DELETE /v1/notes/:id' do
    let(:note) { create(:note, user: user) }

    it 'requires authentication' do
      delete "/v1/notes/#{note.id}"
      expect(response.status).to eq(401)
    end

    it 'fails if not admin' do
      user.remove_admin!
      user.save

      delete "/v1/notes/#{note.id}", headers: auth_headers
      expect(response.status).to eq(403)
    end

    it 'fails if not note owner' do
      other_note = create(:note)

      delete "/v1/notes/#{other_note.id}", headers: auth_headers
      expect(response.status).to eq(403)
    end

    it 'successfully deletes' do
      delete "/v1/notes/#{note.id}", headers: auth_headers
      expect(response.status).to eq(200)
      expect(json).to include('body' => note.body)
    end

    it 'can be revived after deletion' do
      delete "/v1/notes/#{note.id}", headers: auth_headers
      expect(response.status).to eq(200)

      get "/v1/notes/#{note.id}", headers: auth_headers
      expect(response.status).to eq(404)

      note.reload.restore

      get "/v1/notes/#{note.id}", headers: auth_headers
      expect(response.status).to eq(200)
      expect(json).to include('body' => note.body)
    end
  end
end
