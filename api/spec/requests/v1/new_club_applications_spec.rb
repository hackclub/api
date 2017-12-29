require 'rails_helper'

RSpec.describe 'V1::NewClubApplications', type: :request do
  let(:applicant) do
    a = create(:applicant)
    a.generate_login_code!
    a.generate_auth_token!
    a.save

    a
  end
  let(:auth_headers) { { 'Authorization': "Bearer #{applicant.auth_token}" } }

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

  describe 'GET /v1/new_club_applications/:id' do
    let(:club_application) { create(:new_club_application) }

    before { applicant.new_club_applications << club_application }

    it 'requires authentication' do
      get "/v1/new_club_applications/#{club_application.id}"
      expect(response.status).to eq(401)
    end

    it 'errors when authed applicant does not own application' do
      other_application = create(:new_club_application)

      get "/v1/new_club_applications/#{other_application.id}",
        headers: auth_headers

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end

    it 'renders application when properly authed' do
      club_application.update_attributes(
        high_school_name: 'Superhero High School'
      )

      get "/v1/new_club_applications/#{club_application.id}",
        headers: auth_headers

      expect(response.status).to eq(200)
      expect(json).to include('high_school_name' => 'Superhero High School')

      # includes list of applicant profiles w/ applicant ids and emails
      profile = ApplicantProfile.find_by(
        applicant: applicant,
        new_club_application: club_application
      )
      expect(json['applicant_profiles'].first).to eq(
        'id' => profile.id,
        'applicant' => {
          'id' => profile.applicant.id,
          'email' => profile.applicant.email
        }
      )
    end

    it '404s when application does not exist' do
      get "/v1/new_club_applications/#{club_application.id + 1}",
        headers: auth_headers

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
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

  describe 'POST /v1/new_club_applications/:id/add_applicant' do
    let(:club_application) { create(:new_club_application) }

    before { applicant.new_club_applications << club_application }

    it 'requires authentication' do
      post "/v1/new_club_applications/#{club_application.id}/add_applicant",
        params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(401)
    end

    it "fails when trying to add to someone else's application" do
      other_application = create(:new_club_application)

      post "/v1/new_club_applications/#{other_application.id}/add_applicant",
        headers: auth_headers,
        params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end

    it '404s when given application id does not exist' do
      post "/v1/new_club_applications/#{club_application.id + 1}/add_applicant",
        headers: auth_headers,
        params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
    end

    it 'creates new applicant and sends email when given email is new' do
      starting_applicant_count = Applicant.count

      post "/v1/new_club_applications/#{club_application.id}/add_applicant",
        headers: auth_headers,
        params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(200)
      expect(json).to include('success' => true)

      # new applicant created and added to application
      expect(Applicant.count).to eq(starting_applicant_count + 1)
      expect(
        club_application.applicants.find_by(email: 'john@johnsmith.com')
      ).to_not be_nil

      # email sent
      expect(ApplicantMailer.deliveries.length).to be(1)
    end

    it 'adds existing applicant and sends email when given email is not new' do
      new_applicant = create(:applicant)
      starting_applicant_count = Applicant.count

      post "/v1/new_club_applications/#{club_application.id}/add_applicant",
        headers: auth_headers,
        params: { email: new_applicant.email }

      expect(response.status).to eq(200)
      expect(json).to include('success' => true)

      # no new applicants created
      expect(starting_applicant_count).to eq(Applicant.count)

      # applicant successfully added to application
      expect(club_application.applicants).to include(new_applicant)

      # email sent
      expect(ApplicantMailer.deliveries.length).to be(1)
    end

    it 'fails when applicant has already been added' do
      new_applicant = create(:applicant)
      club_application.applicants << new_applicant

      post "/v1/new_club_applications/#{club_application.id}/add_applicant",
        headers: auth_headers,
        params: { email: new_applicant.email }

      expect(response.status).to eq(422)
      expect(json['errors']['email']).to include('already added')
    end
  end
end
