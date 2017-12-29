require 'rails_helper'

RSpec.describe 'V1::ApplicantProfiles', type: :request do
  let(:profile) { create(:applicant_profile) }
  let(:applicant) do
    profile.applicant.generate_auth_token!
    profile.applicant.save

    profile.applicant
  end
  let(:application) { profile.application }

  let(:auth_headers) { { 'Authorization': "Bearer #{applicant.auth_token}" } }

  describe 'GET /v1/applicant_profiles/:id' do
    it 'requires authentication' do
      get "/v1/applicant_profiles/#{profile.id}"
      expect(response.status).to eq(401)
    end

    it 'returns the requested applicant profile' do
      get "/v1/applicant_profiles/#{profile.id}", headers: auth_headers

      expect(response.status).to eq(200)
      expect(json).to include('leader_name')
    end

    it "refuses to return someone else's applicant profile" do
      other_profile = create(:applicant_profile)

      get "/v1/applicant_profiles/#{other_profile.id}", headers: auth_headers

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end

    it "404s if profile doesn't exist" do
      get "/v1/applicant_profiles/#{profile.id + 1}", headers: auth_headers

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
    end
  end

  describe 'PATCH /v1/applicant_profile/id' do
    it 'requires authentication' do
      patch "/v1/applicant_profiles/#{profile.id}"
      expect(response.status).to eq(401)
    end

    it 'updates the given fields' do
      patch "/v1/applicant_profiles/#{profile.id}",
        headers: auth_headers,
        params: {
          leader_name: 'John Doe',
          leader_email: 'john@johndoe.com'
        }

      expect(response.status).to eq(200)
      expect(json).to include(
        'leader_name' => 'John Doe',
        'leader_email' => 'john@johndoe.com'
      )
    end

    it "refuses to update someone else's profile" do
      other_profile = create(:applicant_profile)

      patch "/v1/applicant_profiles/#{other_profile.id}",
        headers: auth_headers,
        params: {
          leader_name: 'John Doe'
        }

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end

    it "404s if profile doesn't exist" do
      patch "/v1/applicant_profiles/#{profile.id + 1}",
        headers: auth_headers,
        params: {
          leader_name: 'John Doe'
        }

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
    end
  end
end
