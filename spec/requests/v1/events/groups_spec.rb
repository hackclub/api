# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Events::Groups', type: :request do
  let(:user) { nil } # set in subtests
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  # set these in subtests
  let(:params) { {} }
  let(:headers) { {} }
  let(:method) { :get }
  let(:url) { '' }
  let(:setup) {} # override this to do any setup you'd usually do in before

  before do
    setup
    send(method, url, params: params, headers: headers)
  end

  describe 'POST /v1/events/groups' do
    let(:method) { :post }
    let(:url) { '/v1/workshops/groups' }

    it 'fails without admin'

    context 'as admin' do
      it 'fails without params'

      context 'with params' do
        it 'succeeds'
      end
    end
  end

  describe 'PATCH /v1/events/groups/:id' do
    it 'fails without admin'

    context 'as admin' do
      it 'succeeds'

      context 'with bad params' do
        it 'gracefully fails'
      end
    end
  end

  describe 'GET /v1/events/groups' do
    let(:method) { :get }
    let(:url) { '/v1/events/groups' }

    let(:setup) { create_list(:event_group, 5) }

    it 'lists all event groups' do
      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end
  end

  describe 'GET /v1/events/groups/:id' do
    let(:group) { create(:event_group_w_photos) }

    let(:method) { :get }
    let(:url) { "/v1/events/groups/#{group.id}" }

    it 'shows correct params for given event group' do
      expect(response.status).to eq(200)
      expect(json).to include(
        'id',
        'created_at',
        'updated_at',
        'name',
        'location',
        'logo',
        'banner'
      )
      expect(json['logo']).to include(
        'id',
        'created_at',
        'updated_at',
        'type',
        'file_path'
      )
      expect(json['banner']).to include(
        'id',
        'created_at',
        'updated_at',
        'type',
        'file_path'
      )
    end
  end

  describe 'DELETE /v1/events/groups'
end
