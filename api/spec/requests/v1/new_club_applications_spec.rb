require 'rails_helper'

RSpec.describe 'V1::NewClubApplications', type: :request do
  describe 'GET /v1/applicants/:id/new_club_applications' do
    let(:applicant) do
      a = create(:applicant)
      a.generate_login_code!
      a.generate_auth_token!
      a.save

      a
    end

    let(:auth_token) { applicant.auth_token }

    it 'errors when auth header is not present' do
      get "/v1/applicants/#{applicant.id}/new_club_applications"

      expect(response.status).to eq(401)
      expect(json).to include('error' => 'authorization is required')
    end

    it 'errors when auth token is nil' do
      # create applicant with nil auth token to try and trick it
      create(:applicant)

      get "/v1/applicants/#{applicant.id}/new_club_applications", headers: {
        'Authorization': 'Bearer'
      }

      expect(response.status).to eq(401)
      expect(json).to include('error' => 'authorization is invalid')
    end

    it 'errors when auth token is incorrect' do
      get "/v1/applicants/#{applicant.id}/new_club_applications", headers: {
        'Authorization': 'Bearer notarealtoken'
      }

      expect(response.status).to eq(401)
      expect(json).to include('error' => 'authorization is invalid')
    end

    it 'lists club applications with valid auth token' do
      5.times do
        applicant.new_club_applications << NewClubApplication.create
      end

      get "/v1/applicants/#{applicant.id}/new_club_applications", headers: {
        'Authorization': "Bearer #{auth_token}"
      }

      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end
  end
end
