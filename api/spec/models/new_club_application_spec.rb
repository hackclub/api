# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewClubApplication, type: :model do
  ## db columns ##

  # relations
  it { should have_db_column :point_of_contact_id }

  # school
  it { should have_db_column :high_school_name }
  it { should have_db_column :high_school_url }
  it { should have_db_column :high_school_type }
  it { should have_db_column :high_school_address }
  it { should have_db_column :high_school_latitude }
  it { should have_db_column :high_school_longitude }
  it { should have_db_column :high_school_parsed_address }
  it { should have_db_column :high_school_parsed_city }
  it { should have_db_column :high_school_parsed_state }
  it { should have_db_column :high_school_parsed_state_code }
  it { should have_db_column :high_school_parsed_postal_code }
  it { should have_db_column :high_school_parsed_country }
  it { should have_db_column :high_school_parsed_country_code }

  # leaders
  it { should have_db_column :leaders_video_url }
  it { should have_db_column :leaders_interesting_project }
  it { should have_db_column :leaders_team_origin_story }

  # progress
  it { should have_db_column :progress_general }
  it { should have_db_column :progress_student_interest }
  it { should have_db_column :progress_meeting_yet }

  # idea
  it { should have_db_column :idea_why }
  it { should have_db_column :idea_other_coding_clubs }
  it { should have_db_column :idea_other_general_clubs }

  # formation
  it { should have_db_column :formation_registered }
  it { should have_db_column :formation_misc }

  # other
  it { should have_db_column :other_surprising_or_amusing_discovery }

  # curious
  it { should have_db_column :curious_what_convinced }
  it { should have_db_column :curious_how_did_hear }

  # misc

  it { should have_db_column :submitted_at }

  ## enums ##

  it { should define_enum_for :high_school_type }

  ## validations ##

  it_behaves_like 'Geocodeable'

  ## relationships ##

  it { should have_many(:applicant_profiles) }
  it { should have_many(:applicants).through(:applicant_profiles) }
  it { should belong_to(:point_of_contact) }

  it 'requires points of contact to be associated applicants' do
    bad_poc = create(:applicant)

    subject.update_attributes(point_of_contact: bad_poc)

    expect(subject.errors[:point_of_contact])
      .to include('must be an associated applicant')
  end

  describe ':submit!' do
    subject { create(:completed_new_club_application, applicant_count: 3) }
    let(:applicant) { subject.point_of_contact }
    let(:profile) do
      ApplicantProfile.find_by(applicant: applicant,
                               new_club_application: subject)
    end

    it 'fails when missing required fields' do
      subject.update_attributes(progress_general: nil)
      res = subject.submit!

      # failed to submit
      expect(res).to eq(false)
      expect(subject.submitted_at).to be_nil

      # ensure validation errors are present
      expect(subject.errors[:progress_general]).to include "can't be blank"
    end

    it 'fails when applicant profiles are not complete' do
      profile.update_attributes(leader_name: nil)
      res = subject.submit!

      expect(res).to eq(false)
      expect(subject.submitted_at).to be_nil
      expect(subject.errors[:base]).to include(
        'applicant profiles not complete'
      )
    end

    it 'succeeds when required fields are set & applicant profiles complete' do
      res = subject.submit!

      expect(res).to eq(true)
      expect(subject.submitted_at).to be_within(1.minute).of(Time.current)
    end

    # TODO: refactor this into a test that checks for all optional fields?
    it 'does not require high school url' do
      subject.update_attributes(high_school_url: nil)
      res = subject.submit!

      expect(res).to eq(true)
    end

    it 'sends confirmation emails to applicants' do
      subject.submit!

      expect(ApplicantMailer.deliveries.length).to be(3)
    end

    it 'makes the model immutable' do
      subject.submit!

      subject.update_attributes(high_school_name: 'Superhero High School')
      expect(subject.errors[:base]).to include(
        'cannot edit application after submit'
      )
    end
  end
end
