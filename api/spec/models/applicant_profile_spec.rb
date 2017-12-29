# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicantProfile, type: :model do
  ## db columns ##

  # relations
  it { should have_db_column :applicant_id }
  it { should have_db_column :new_club_application_id }

  # leader
  it { should have_db_column :leader_name }
  it { should have_db_column :leader_email }
  it { should have_db_column :leader_age }
  it { should have_db_column :leader_year_in_school }
  it { should have_db_column :leader_gender }
  it { should have_db_column :leader_ethnicity }
  it { should have_db_column :leader_phone_number }
  it { should have_db_column :leader_address }
  it { should have_db_column :leader_latitude }
  it { should have_db_column :leader_longitude }
  it { should have_db_column :leader_parsed_address }
  it { should have_db_column :leader_parsed_city }
  it { should have_db_column :leader_parsed_state }
  it { should have_db_column :leader_parsed_state_code }
  it { should have_db_column :leader_parsed_postal_code }
  it { should have_db_column :leader_parsed_country }
  it { should have_db_column :leader_parsed_country_code }

  # presence
  it { should have_db_column :presence_personal_website }
  it { should have_db_column :presence_github_url }
  it { should have_db_column :presence_linkedin_url }
  it { should have_db_column :presence_facebook_url }
  it { should have_db_column :presence_twitter_url }

  # skills
  it { should have_db_column :skills_system_hacked }
  it { should have_db_column :skills_impressive_achievement }
  it { should have_db_column :skills_is_technical }

  # misc
  it { should have_db_column :completed_at }

  ## enums

  it { should define_enum_for :leader_year_in_school }
  it { should define_enum_for :leader_gender }
  it { should define_enum_for :leader_ethnicity }

  ## validations ##

  it { should validate_presence_of :applicant }
  it { should validate_presence_of :new_club_application }

  it_behaves_like 'Geocodeable'

  ## relationships ##

  it { should belong_to :applicant }
  it { should belong_to :new_club_application }

  describe 'completed_at autosetting / unsetting' do
    let(:unsaved_profile_w_required_fields) do
      profile = ApplicantProfile.new

      # set up relationships
      profile.applicant = create(:applicant)
      profile.new_club_application = create(:new_club_application)

      # leader fields
      profile.leader_name = Faker::Name.name
      profile.leader_email = Faker::Internet.email
      profile.leader_age = [14..18].sample
      profile.leader_year_in_school = :freshman
      profile.leader_gender = :female
      profile.leader_ethnicity = :hispanic_or_latino
      profile.leader_phone_number = '333-333-3333'
      profile.leader_address = HCFaker::Address.full_address

      # not setting presence fields because they're not required

      # skillz fields
      profile.skills_system_hacked = Faker::Lorem.sentence
      profile.skills_impressive_achievement = Faker::Lorem.sentence
      profile.skills_is_technical = true

      profile
    end

    let(:saved_profile_w_required_fields) do
      unsaved_profile_w_required_fields.save
      unsaved_profile_w_required_fields
    end

    it 'should set completed_at when required fields are completed' do
      profile = unsaved_profile_w_required_fields

      expect(profile.completed_at).to be_nil
      profile.save
      expect(profile.completed_at).to_not be_nil
    end

    it 'should not update completed_at when fields are updated' do
      profile = saved_profile_w_required_fields
      starting_completed_at = profile.completed_at

      # let a little time pass
      sleep 0.1

      # modify a required field
      profile.skills_is_technical = false
      profile.save

      # ensure completed_at didn't change
      expect(starting_completed_at).to eq(profile.completed_at)
    end

    it 'should unset completed_at when required fields are unset' do
      profile = saved_profile_w_required_fields

      # make sure completed_at is set
      expect(profile.completed_at).to_not be_nil

      # unset required field
      profile.skills_system_hacked = nil
      profile.save

      # ensure completed_at was unset
      expect(profile.completed_at).to be_nil
    end
  end
end
