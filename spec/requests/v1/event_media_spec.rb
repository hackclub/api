# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::EventMedia', type: :request do
  # override in subtests
  let(:method) { :post }
  let(:url) { '' }
  let(:headers) { {} }
  let(:params) { {} }

  let(:user) { {} } # override in subtests
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  # put anything that needs to happen before the request in an override of this
  let(:setup) { {} }

  let(:event) { create(:event) }

  before do
    # run any needed setup
    setup

    # make http request
    send(method, url, headers: headers, params: params)
  end

  describe 'POST /v1/events/:id/media' do
    let(:method) { :post }
    let(:url) { "/v1/events/#{event.id}/media" }

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires admin' do
        expect(response.status).to eq(403)
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'fails due to invalid params' do
          expect(response.status).to eq(422)
        end

        context 'with event photo' do
          let(:photo) { create(:event_photo) }
          let(:params) { { media_id: photo.id } }

          it 'succeeds' do
            expect(response.status).to eq(200)
            expect(json['success']).to eq(true)
          end
        end

        context 'with invalid attachment type' do
          let(:logo) { create(:event_logo) }
          let(:params) { { media_id: logo.id } }

          it 'fails' do
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end

  describe 'GET /v1/events/:id/media' do
    let(:method) { :get }
    let(:url) { "/v1/events/#{event.id}/media" }

    let(:setup) do
      5.times do
        event.photos << create(:event_photo)
      end
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires admin' do
        expect(response.status).to eq(403)
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'succeeds' do
          expect(response.status).to eq(200)
          expect(json.length).to eq(5)

          expect(json.first).to include('type' => 'event_photo')

          # verify all attributes
          expect(json.first).to include(
            'id',
            'created_at',
            'updated_at',
            'type',
            'file_path',
            'preview_path'
          )
        end
      end
    end
  end

  describe 'DELETE /v1/events/:id/media/:id' do
    let(:photo) { create(:event_photo) }

    let(:method) { :delete }
    let(:url) { "/v1/events/#{event.id}/media/#{photo.id}" }

    let(:setup) do
      event.photos << photo
    end

    it 'requires authentication' do
      expect(response.status).to eq(401)
    end

    context 'when authenticated' do
      let(:user) { create(:user_authed) }
      let(:headers) { auth_headers }

      it 'requires admin' do
        expect(response.status).to eq(403)
      end

      context 'as admin' do
        let(:user) { create(:user_admin_authed) }

        it 'succeeds' do
          expect(response.status).to eq(200)

          # record is actually removed
          expect(event.photos.find_by(id: photo.id)).to eq(nil)
        end
      end
    end
  end
end
