# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::NewClubApplications', type: :request do
  let(:user) { create(:user_authed) }
  let(:auth_headers) { { 'Authorization': "Bearer #{user.auth_token}" } }

  describe 'GET /v1/new_club_applications' do
    it 'requires authentication' do
      get '/v1/new_club_applications'
      expect(response.status).to eq(401)
    end

    it 'requires admin access' do
      get '/v1/new_club_applications', headers: auth_headers
      expect(response.status).to eq(403)
    end

    context 'as admin' do
      let(:user) { create(:user_admin_authed) }

      it 'lists all applications' do
        create(:new_club_application)
        create(:new_club_application)

        get '/v1/new_club_applications', headers: auth_headers

        expect(response.status).to eq(200)
        expect(json.length).to eq(2)
      end

      it 'allows retrieving just submitted applications' do
        create(:new_club_application)
        create(:submitted_new_club_application)

        get '/v1/new_club_applications',
            headers: auth_headers,
            params: {
              submitted: true
            }

        expect(response.status).to eq(200)
        expect(json.length).to eq(1)
      end
    end
  end

  describe 'GET /v1/users/:id/new_club_applications' do
    it 'requires authentication' do
      get "/v1/users/#{user.id}/new_club_applications"
      expect(response.status).to eq(401)
    end

    it 'lists club applications with valid auth token' do
      5.times do
        user.new_club_applications << NewClubApplication.create
      end

      get "/v1/users/#{user.id}/new_club_applications",
          headers: auth_headers

      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end

    it 'refuses to list applications for other users' do
      other_user = create(:user)
      other_user.new_club_applications << create(:new_club_application)

      get "/v1/users/#{other_user.id}/new_club_applications",
          headers: auth_headers

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end
  end

  describe 'POST /v1/users/:id/new_club_applications' do
    it 'requires authentication' do
      post "/v1/users/#{user.id}/new_club_applications"

      expect(response.status).to eq(401)
    end

    it 'creates a new club application with valid auth token' do
      post "/v1/users/#{user.id}/new_club_applications",
           headers: auth_headers

      expect(response.status).to eq(201)
      expect(json).to include('id', 'created_at', 'updated_at')
    end

    it 'sets the point of contact to the user' do
      post "/v1/users/#{user.id}/new_club_applications",
           headers: auth_headers

      expect(response.status).to eq(201)
      expect(json).to include('point_of_contact_id' => user.id)
    end
  end

  describe 'GET /v1/new_club_applications/:id' do
    let(:club_application) { create(:new_club_application) }

    before { user.new_club_applications << club_application }

    it 'requires authentication' do
      get "/v1/new_club_applications/#{club_application.id}"
      expect(response.status).to eq(401)
    end

    it 'errors when authed user does not own application' do
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

      # includes list of leader profile ids, status, and user info
      profile = LeaderProfile.find_by(
        user: user,
        new_club_application: club_application
      )
      expect(json['leader_profiles'].first).to eq(
        'id' => profile.id,
        'completed_at' => profile.completed_at,
        'user' => {
          'id' => profile.user.id,
          'email' => profile.user.email
        }
      )

      # includes interviewed_at and interview_duration, but not interview_notes
      expect(json).to include('interviewed_at')
      expect(json).to include('interview_duration')
      expect(json).to_not include('interview_notes')

      # includes rejected_at, but not rejected_reason or rejected_notes
      expect(json).to include('rejected_at')
      expect(json).to_not include('rejected_reason')
      expect(json).to_not include('rejected_notes')
    end

    it 'includes private fields when authed as an admin' do
      user.make_admin!
      user.save

      get "/v1/new_club_applications/#{club_application.id}",
          headers: auth_headers

      expect(response.status).to eq(200)

      expect(json).to include('interviewed_at')
      expect(json).to include('interview_duration')
      expect(json).to include('interview_notes')

      expect(json).to include('rejected_at')
      expect(json).to include('rejected_reason')
      expect(json).to include('rejected_notes')
    end

    it '404s when application does not exist' do
      get "/v1/new_club_applications/#{club_application.id + 1}",
          headers: auth_headers

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
    end
  end

  describe 'PATCH /v1/new_club_applications/:id' do
    let(:club_application) do
      app = create(:new_club_application)
      app.users << user
      app
    end

    it 'requires_authentication' do
      patch "/v1/new_club_applications/#{club_application.id}", params: {
        high_school_name: 'Superhero High School'
      }

      expect(response.status).to eq(401)
    end

    it 'errors when auth token is for the wrong user' do
      other_user = create(:user)
      other_user.generate_auth_token!
      other_user.save

      patch "/v1/new_club_applications/#{club_application.id}",
            headers: {
              'Authorization': "Bearer #{other_user.auth_token}"
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

    it 'sets point of contact with valid auth token' do
      poc = create(:user)
      club_application.users << poc

      patch "/v1/new_club_applications/#{club_application.id}",
            headers: auth_headers,
            params: {
              point_of_contact_id: poc.id
            }

      expect(response.status).to eq(200)
      expect(json).to include('point_of_contact_id' => poc.id)
    end

    it 'fails to set point of contact when not associated' do
      bad_poc = create(:user)

      patch "/v1/new_club_applications/#{club_application.id}",
            headers: auth_headers,
            params: {
              point_of_contact_id: bad_poc.id
            }

      expect(response.status).to eq(422)
      expect(json['errors']).to include('point_of_contact')
    end

    it 'does not update non-user writeable fields' do
      club_application.update_attributes(high_school_latitude: 12)

      patch "/v1/new_club_applications/#{club_application.id}",
            headers: auth_headers,
            params: {
              high_school_latitude: 42
            }

      # feel like this should probably error, but not sure how to best handle
      # errors for when the user tries to update a read-only field, so
      # going to just 200 for the time being.
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

    it 'fails to update fields when application has been submitted' do
      application = create(:completed_new_club_application)
      create(:completed_leader_profile,
             new_club_application: application, user: user)
      application.update_attributes(point_of_contact: user)

      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers

      patch "/v1/new_club_applications/#{application.id}",
            headers: auth_headers,
            params: { high_school_name: 'Foo High School' }

      expect(response.status).to eq(422)
      expect(
        json['errors']['base']
      ).to include('cannot edit application after submit')
    end

    it 'fails to update interview fields' do
      application = create(:completed_new_club_application)
      create(:completed_leader_profile, new_club_application: application,
                                        user: user)
      application.update_attributes(point_of_contact: user)

      # application must be submitted for any modification (even by admins) to
      # be allowed
      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers

      patch "/v1/new_club_applications/#{application.id}",
            headers: auth_headers,
            params: {
              interviewed_at: Time.current,
              interview_duration: 30.minutes,
              interview_notes: 'Went well.'
            }

      expect(response.status).to eq(422)
    end

    it 'fails to update rejection fields' do
      application = create(:completed_new_club_application)
      create(:completed_leader_profile, new_club_application: application,
                                        user: user)
      application.update_attributes(point_of_contact: user)

      # application must be submitted for any modification (even by admins) to
      # be allowed
      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers

      patch "/v1/new_club_applications/#{application.id}",
            headers: auth_headers,
            params: {
              rejected_at: Time.current,
              rejected_reason: :other,
              rejected_notes: 'Example reason'
            }

      expect(response.status).to eq(422)
    end

    context 'when admin' do
      let(:club_application) do
        app = create(:completed_new_club_application)
        app.submit!
        app.save

        app
      end

      before do
        user.make_admin!
        user.save
      end

      it 'allows updating interview fields' do
        patch "/v1/new_club_applications/#{club_application.id}",
              headers: auth_headers,
              params: {
                interviewed_at: Time.current,
                interview_duration: 30.minutes,
                interview_notes: 'Went well.'
              }

        expect(response.status).to eq(200)
        expect(
          Time.zone.parse(json['interviewed_at'])
        ).to be_within(3.seconds).of(Time.current)
        expect(json).to include('interview_duration' => 30.minutes)
        expect(json).to include('interview_notes' => 'Went well.')
      end

      it 'fails if not all interview fields are set' do
        patch "/v1/new_club_applications/#{club_application.id}",
              headers: auth_headers,
              params: {
                interviewed_at: Time.current
              }

        expect(response.status).to eq(422)
        expect(json['errors']).to include('interview_duration')
        expect(json['errors']).to include('interview_notes')
      end

      it 'fails to update interview fields if application is not submitted' do
        club_application = create(:new_club_application)

        patch "/v1/new_club_applications/#{club_application.id}",
              headers: auth_headers,
              params: {
                interviewed_at: Time.current
              }

        expect(response.status).to eq(422)
        expect(json['errors']['submitted_at']).to include("can't be blank")
      end

      it 'allows updating rejected fields' do
        patch "/v1/new_club_applications/#{club_application.id}",
              headers: auth_headers,
              params: {
                rejected_at: Time.current,
                rejected_reason: :other,
                rejected_notes: 'Example reason'
              }

        expect(response.status).to eq(200)
        expect(
          Time.zone.parse(json['rejected_at'])
        ).to be_within(3.seconds).of(Time.current)
        expect(json).to include('rejected_reason' => 'other')
        expect(json).to include('rejected_notes' => 'Example reason')
      end

      it 'fails if not all rejected fields are set' do
        patch "/v1/new_club_applications/#{club_application.id}",
              headers: auth_headers,
              params: {
                rejected_at: Time.current
              }

        expect(response.status).to eq(422)
        expect(json['errors']).to include('rejected_reason', 'rejected_notes')
      end

      it 'fails to update rejected fields if application is not submitted' do
        club_application = create(:new_club_application)

        patch "/v1/new_club_applications/#{club_application.id}",
              headers: auth_headers,
              params: {
                rejected_at: Time.current
              }

        expect(response.status).to eq(422)
        expect(json['errors']['submitted_at']).to include("can't be blank")
      end
    end
  end

  describe 'POST /v1/new_club_applications/:id/add_user' do
    let(:club_application) { create(:new_club_application) }

    before { user.new_club_applications << club_application }

    it 'requires authentication' do
      post "/v1/new_club_applications/#{club_application.id}/add_user",
           params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(401)
    end

    it "fails when trying to add to someone else's application" do
      other_application = create(:new_club_application)

      post "/v1/new_club_applications/#{other_application.id}/add_user",
           headers: auth_headers,
           params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end

    it '404s when given application id does not exist' do
      post "/v1/new_club_applications/#{club_application.id + 1}/add_user",
           headers: auth_headers,
           params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
    end

    it 'creates new user and sends email when given email is new' do
      starting_profile_count = User.count

      post "/v1/new_club_applications/#{club_application.id}/add_user",
           headers: auth_headers,
           params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(200)
      expect(json).to include('success' => true)

      # new user created and added to application
      expect(User.count).to eq(starting_profile_count + 1)
      expect(
        club_application.users.find_by(email: 'john@johnsmith.com')
      ).to_not be_nil

      # email sent
      expect(ApplicantMailer.deliveries.length).to be(1)
    end

    it 'adds existing user and sends email when given email is not new' do
      new_user = create(:user)
      starting_profile_count = User.count

      post "/v1/new_club_applications/#{club_application.id}/add_user",
           headers: auth_headers,
           params: { email: new_user.email }

      expect(response.status).to eq(200)
      expect(json).to include('success' => true)

      # no new users created
      expect(starting_profile_count).to eq(User.count)

      # user successfully added to application
      expect(club_application.users).to include(new_user)

      # email sent
      expect(ApplicantMailer.deliveries.length).to be(1)
    end

    it 'rehydrates leader profile when one was previously deleted' do
      to_readd = create(:user)
      to_rehydrate = create(:leader_profile,
                            user: to_readd,
                            new_club_application: club_application)
      to_rehydrate.update_attributes(leader_name: 'Jerry')
      to_rehydrate.destroy

      post "/v1/new_club_applications/#{club_application.id}/add_user",
           headers: auth_headers,
           params: { email: to_readd.email }

      # request successful
      expect(response.status).to eq(200)

      # successfully rehydrated
      expect(LeaderProfile.find_by(
        user: to_readd,
        new_club_application: club_application
      ).leader_name).to eq('Jerry')
    end

    it 'fails when user has already been added' do
      new_user = create(:user)
      club_application.users << new_user

      post "/v1/new_club_applications/#{club_application.id}/add_user",
           headers: auth_headers,
           params: { email: new_user.email }

      expect(response.status).to eq(422)
      expect(json['errors']['email']).to include('already added')
    end

    it 'fails when application has been submitted' do
      application = create(:completed_new_club_application)
      create(:completed_leader_profile,
             new_club_application: application, user: user)
      application.update_attributes(point_of_contact: user)

      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers

      post "/v1/new_club_applications/#{application.id}/add_user",
           headers: auth_headers,
           params: { email: 'john@johnsmith.com' }

      expect(response.status).to eq(422)
      expect(
        json['errors']['base']
      ).to include('cannot edit application after submit')
    end
  end

  describe 'DELETE /v1/new_club_applications/:id/remove_user' do
    let(:application) { create(:completed_new_club_application) }

    before do
      create(:completed_leader_profile, user: user,
                                        new_club_application: application)
      application.update_attributes(point_of_contact: user)
    end

    it 'requires authentication' do
      delete "/v1/new_club_applications/#{application.id}/remove_user",
             params: { user_id: user.id }

      expect(response.status).to eq(401)
    end

    it '404s when application does not exist' do
      delete "/v1/new_club_applications/#{application.id + 1}/remove_user",
             headers: auth_headers,
             params: { user_id: user.id }

      expect(response.status).to eq(404)
      expect(json['error']).to eq('not found')
    end

    it 'fails to delete from club applications of other users' do
      other_app = create(:new_club_application)
      other_user = create(:user)

      other_app.users << other_user

      delete "/v1/new_club_applications/#{other_app.id}/remove_user",
             headers: auth_headers,
             params: { user_id: other_user.id }

      expect(response.status).to eq(403)
      expect(json['error']).to eq('access denied')
    end

    it 'fails to delete if not point of contact' do
      application.update_attributes(point_of_contact: nil)
      other_user = create(:user, new_club_applications: [application])

      delete "/v1/new_club_applications/#{application.id}/remove_user",
             headers: auth_headers,
             params: { user_id: other_user.id }

      expect(response.status).to eq(403)
      expect(json['error']).to eq('access denied')
    end

    it 'fails to delete self' do
      delete "/v1/new_club_applications/#{application.id}/remove_user",
             headers: auth_headers,
             params: { user_id: user.id }

      expect(response.status).to eq(422)
      expect(json['errors']['user_id']).to include('cannot remove self')
    end

    it '404s when user does not exist' do
      delete "/v1/new_club_applications/#{application.id}/remove_user",
             headers: auth_headers,
             params: { user_id: user.id + 100 }

      expect(response.status).to eq(404)
      expect(json['error']).to eq('not found')
    end

    it 'fails to delete users already deleted' do
      other_user = create(:user, new_club_applications: [application])

      2.times do
        delete "/v1/new_club_applications/#{application.id}/remove_user",
               headers: auth_headers,
               params: { user_id: other_user.id }
      end

      expect(response.status).to eq(422)
      expect(
        json['errors']['user_id']
      ).to include('not added to application')
    end

    it 'fails to delete user when application is submitted' do
      application.submit!

      delete "/v1/new_club_applications/#{application.id}/remove_user",
             headers: auth_headers,
             params: { user_id: application.users.last.id }

      expect(response.status).to eq(422)
      expect(
        json['errors']['base']
      ).to include('cannot edit application after submit')
    end

    it 'successfully deletes if point of contact' do
      delete "/v1/new_club_applications/#{application.id}/remove_user",
             headers: auth_headers,
             params: { user_id: application.users.last.id }

      expect(response.status).to eq(200)
      expect(json).to include('success' => true)
    end

    it 'preserves profile data on deletion' do
      to_delete = application.users.last

      delete "/v1/new_club_applications/#{application.id}/remove_user",
             headers: auth_headers,
             params: { user_id: to_delete.id }

      deleted_profile = LeaderProfile.with_deleted.find_by(
        user: user,
        new_club_application: application
      )

      expect(deleted_profile).to_not be_nil
    end
  end

  describe 'POST /v1/new_club_applications/:id/submit' do
    let(:application) do
      create(:completed_new_club_application,
             profile_count: 0)
    end

    # add our user w/ a completed profile
    let!(:profile) do
      create(
        :completed_leader_profile,
        user: user, new_club_application: application
      )
    end

    # and make them the point of contact
    before { application.update_attributes(point_of_contact: user) }

    it 'requires authentication' do
      post "/v1/new_club_applications/#{application.id}/submit"
      expect(response.status).to eq(401)
    end

    it "fails when trying to submit someone else's application" do
      other_application = create(:new_club_application)

      post "/v1/new_club_applications/#{other_application.id}/submit",
           headers: auth_headers

      expect(response.status).to eq(403)
      expect(json).to include('error' => 'access denied')
    end

    it "404s when given application id doesn't exist" do
      post "/v1/new_club_applications/#{application.id + 1}/submit",
           headers: auth_headers

      expect(response.status).to eq(404)
      expect(json).to include('error' => 'not found')
    end

    it 'returns validation errors when fields are missing' do
      application.update_attributes(formation_registered: nil)

      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers

      expect(response.status).to eq(422)
      expect(json['errors']).to include('formation_registered')
    end

    it 'fails when leader profiles are not completed' do
      profile.update_attributes(leader_name: nil)

      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers

      expect(response.status).to eq(422)
      expect(
        json['errors']['base']
      ).to include('leader profiles not complete')
    end

    it 'fails if already submitted' do
      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers
      expect(response.status).to eq(200)

      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers
      expect(response.status).to eq(422)
      expect(json['errors']['base']).to include('already submitted')
    end

    it 'submits successfully when all fields are present' do
      post "/v1/new_club_applications/#{application.id}/submit",
           headers: auth_headers

      expect(response.status).to eq(200)
      expect(
        Time.zone.parse(json['submitted_at'])
      ).to be_within(1.minute).of(Time.current)
    end
  end

  describe 'POST /v1/new_club_applications/:id/accept' do
    let(:application) do
      create(:interviewed_new_club_application)
    end

    # make user admin
    before do
      user.make_admin!
      user.save
    end

    it 'requires authentication' do
      post "/v1/new_club_applications/#{application.id}/accept"
      expect(response.status).to eq(401)
    end

    it 'fails if not admin' do
      user.remove_admin!
      user.save

      post "/v1/new_club_applications/#{application.id}/accept",
           headers: auth_headers

      expect(response.status).to eq(403)
    end

    it 'fails if not submitted' do
      application = create(:completed_new_club_application)

      post "/v1/new_club_applications/#{application.id}/accept",
           headers: auth_headers

      expect(response.status).to eq(422)
      expect(json['errors']['submitted_at']).to include("can't be blank")
    end

    it 'fails if not interviewed' do
      application = create(:submitted_new_club_application)

      post "/v1/new_club_applications/#{application.id}/accept",
           headers: auth_headers

      expect(response.status).to eq(422)
      expect(json['errors']['interviewed_at']).to include("can't be blank")
    end

    it 'fails if already accepted' do
      post "/v1/new_club_applications/#{application.id}/accept",
           headers: auth_headers
      expect(response.status).to eq(200)

      post "/v1/new_club_applications/#{application.id}/accept",
           headers: auth_headers
      expect(response.status).to eq(422)
      expect(json['errors']['base']).to include('already accepted')
    end

    it 'fails if rejected' do
      patch "/v1/new_club_applications/#{application.id}",
            headers: auth_headers,
            params: {
              rejected_at: Time.current,
              rejected_reason: :other,
              rejected_notes: 'Test notes'
            }
      expect(response.status).to eq(200)

      post "/v1/new_club_applications/#{application.id}/accept",
           headers: auth_headers
      expect(response.status).to eq(422)
      expect(json['errors']['rejected_at']).to include('must be blank')
    end

    it 'succeeds when submitted, interviewed, and not already accepted' do
      post "/v1/new_club_applications/#{application.id}/accept",
           headers: auth_headers

      expect(response.status).to eq(200)
      expect(
        Time.zone.parse(json['accepted_at'])
      ).to be_within(1.minute).of(Time.current)
    end
  end
end
