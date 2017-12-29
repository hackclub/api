require 'rails_helper'

RSpec.describe 'V1::NewClubApplications', type: :request do
  let(:applicant) do
    a = create(:applicant)
    a.generate_login_code!
    a.generate_auth_token!
    a.save

    a
  end
  let(:auth_token) { applicant.auth_token }
  let(:auth_headers) { { 'Authorization': "Bearer #{auth_token}" } }

  # single out one authenticated route & test common logic on it
  describe 'authentication' do
    it 'errors when auth header is not present' do
      get "/v1/applicants/#{applicant.id}/new_club_applications"

      expect(response.status).to eq(401)
      expect(json).to include('error' => 'authorization required')
    end

    it 'errors when auth token is nil' do
      # create applicant with nil auth token to try and trick it
      create(:applicant)

      get "/v1/applicants/#{applicant.id}/new_club_applications", headers: {
        'Authorization': 'Bearer'
      }

      expect(response.status).to eq(401)
      expect(json).to include('error' => 'authorization invalid')
    end

    it 'errors when auth token is incorrect' do
      get "/v1/applicants/#{applicant.id}/new_club_applications", headers: {
        'Authorization': 'Bearer notarealtoken'
      }

      expect(response.status).to eq(401)
      expect(json).to include('error' => 'authorization invalid')
    end
  end

  describe 'GET /v1/applicants/:id/new_club_applications' do
    it 'requires authentication' do
      get "/v1/applicants/#{applicant.id}/new_club_applications"
      expect(response.status).to eq(401)
    end

    it 'lists club applications with valid auth token' do
      5.times do
        applicant.new_club_applications << NewClubApplication.create
      end

      get "/v1/applicants/#{applicant.id}/new_club_applications",
        headers: auth_headers

      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end

    it 'refuses to list applications for other applicants' do
      other_applicant = create(:applicant)
      other_applicant.new_club_applications << create(:new_club_application)

      get "/v1/applicants/#{other_applicant.id}/new_club_applications",
        headers: auth_headers

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end
  end

  describe 'POST /v1/applicants/:id/new_club_applications' do
    it 'requires authentication' do
      post "/v1/applicants/#{applicant.id}/new_club_applications"

      expect(response.status).to eq(401)
    end

    it 'creates a new club application with valid auth token' do
      post "/v1/applicants/#{applicant.id}/new_club_applications",
        headers: auth_headers

      expect(response.status).to eq(201)
      expect(json).to include('id', 'created_at', 'updated_at')
    end
  end

  describe 'PATCH /v1/new_club_applications/:id' do
    let(:club_application) { create(:new_club_application) }

    before { applicant.new_club_applications << club_application }

    it 'requires_authentication' do
      patch "/v1/new_club_applications/#{club_application.id}", params: {
        high_school_name: 'Superhero High School'
      }

      expect(response.status).to eq(401)
    end

    it 'errors when auth token is for the wrong applicant' do
      other_applicant = create(:applicant)
      other_applicant.generate_auth_token!
      other_applicant.save

      patch "/v1/new_club_applications/#{club_application.id}",
        headers: {
          'Authorization': "Bearer #{other_applicant.auth_token}"
        },
        params: {
          high_school_name: 'Superhero High School'
        }

        expect(response.status).to eq(403)
        expect(json).to include('error' => 'access denied')
    end

    it 'updates given fields with valid auth token' do
      patch "/v1/new_club_applications/#{club_application.id}",
        headers: auth_headers,
        params: {
          high_school_name: 'Superhero High School',
          leaders_team_origin_story: 'We were all stung by a spider...'
        }

      expect(response.status).to eq(200)
      expect(json).to include(
        'high_school_name' => 'Superhero High School',
        'leaders_team_origin_story' => 'We were all stung by a spider...'
      )
    end

    it 'does not update non-user writeable fields' do
      club_application.update_attributes(high_school_latitude: 12)

      patch "/v1/new_club_applications/#{club_application.id}",
        headers: auth_headers,
        params: {
          high_school_latitude: 42
        }

        # feel like this should probably error, but not sure how to best handle
        # errors for when the user tries to update a read-only field, so going
        # to just 200 for the time being.
        expect(response.status).to eq(200)
        expect(json).to include('high_school_latitude' => '12.0')
    end

    it 'geocodes high school address' do
      patch "/v1/new_club_applications/#{club_application.id}",
        headers: auth_headers,
        params: {
          high_school_address: '1 Infinite Loop'
        }

      expect(response.status).to eq(200)

      expect(json['high_school_address']).to eq('1 Infinite Loop')
      expect(json['high_school_latitude']).to_not be_nil
      expect(json['high_school_longitude']).to_not be_nil
      expect(json['high_school_parsed_city']).to_not be_nil
      expect(json['high_school_parsed_state']).to_not be_nil
      expect(json['high_school_parsed_state_code']).to_not be_nil
      expect(json['high_school_parsed_postal_code']).to_not be_nil
      expect(json['high_school_parsed_country']).to_not be_nil
      expect(json['high_school_parsed_country_code']).to_not be_nil
    end
  end
end
