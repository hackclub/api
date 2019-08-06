# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewClubApplication, type: :model do
  ## db columns ##

  # relations
  it { should have_db_column :owner_id }
  it { should have_db_column :point_of_contact_id }
  it { should have_db_column :new_club_id }

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

  it { should have_db_column :interviewed_at }
  it { should have_db_column :interview_duration }
  it { should have_db_column :interview_notes }

  it { should have_db_column :rejected_at }
  it { should have_db_column :rejected_reason }
  it { should have_db_column :rejected_notes }

  it { should have_db_column :accepted_at }

  it { should have_db_column :test }

  ## enums ##

  it { should define_enum_for :high_school_type }
  it { should define_enum_for(:rejected_reason).with(%i[other dev]) }

  ## validations ##

  it_behaves_like 'Geocodeable'

  ## relationships ##

  it { should have_many(:leader_profiles) }
  it { should have_many(:users).through(:leader_profiles) }

  it { should belong_to(:owner) }
  it { should belong_to(:point_of_contact) }
  it { should have_many :notes }

  it { should belong_to :new_club }

  it 'sets test to false by default' do
    expect(NewClubApplication.new.test).to eq(false)
  end

  it 'does not allow test to be nil' do
    app = build(:new_club_application)

    expect(app.valid?).to eq(true)

    app.test = nil

    expect(app.valid?).to eq(false)
  end

  it 'requires points of contact to be associated users' do
    bad_poc = create(:user)

    subject.update_attributes(point_of_contact: bad_poc)

    expect(subject.errors[:point_of_contact])
      .to include('must be an associated applicant')
  end

  describe 'interview fields' do
    subject { create(:completed_new_club_application) }
    before { subject.submit! }

    it 'does not allow interviewed_at to be set unless submitted_at is' do
      subject.submitted_at = nil
      subject.interviewed_at = Time.current

      subject.validate
      expect(subject.errors).to include('submitted_at')
    end

    it 'should require other fields to be set if interviewed_at is' do
      expect(subject.valid?).to be(true)

      subject.interviewed_at = Time.current

      subject.validate
      expect(subject.errors).to include('interview_duration')
      expect(subject.errors).to include('interview_notes')
    end

    it 'should require other fields to be set if interview_duration is' do
      expect(subject.valid?).to be(true)

      subject.interview_duration = 1.hour

      subject.validate
      expect(subject.errors).to include('interviewed_at')
      expect(subject.errors).to include('interview_notes')
    end

    it 'should require other fields to be set if interview_notes is' do
      expect(subject.valid?).to be(true)

      subject.interview_notes = "They're ready to start."

      subject.validate
      expect(subject.errors).to include('interviewed_at')
      expect(subject.errors).to include('interview_duration')
    end

    it 'is valid if all interview fields are set' do
      subject.interviewed_at = Time.current
      subject.interview_duration = 1.hour
      subject.interview_notes = 'Ready to go.'
      expect(subject.valid?).to eq(true)
    end
  end

  describe 'rejected fields' do
    subject { create(:completed_new_club_application) }
    before { subject.submit! }

    it 'does not allow rejected_at to be set unless submitted_at is' do
      subject.submitted_at = nil
      subject.rejected_at = Time.current

      subject.validate
      expect(subject.errors).to include('submitted_at')
    end

    it 'should require other fields to be set if rejected_at is' do
      expect(subject.valid?).to be(true)

      subject.rejected_at = Time.current

      subject.validate
      expect(subject.errors).to include('rejected_reason')
      expect(subject.errors).to include('rejected_notes')
    end

    it 'should require other fields to be set if rejected_reason is' do
      expect(subject.valid?).to be(true)

      subject.rejected_reason = :other

      subject.validate
      expect(subject.errors).to include('rejected_at')
      expect(subject.errors).to include('rejected_notes')
    end

    it 'should require other fields to be set if rejected_notes is' do
      expect(subject.valid?).to be(true)

      subject.rejected_notes = "Didn't have faith in leadship skills."

      subject.validate
      expect(subject.errors).to include('rejected_at')
      expect(subject.errors).to include('rejected_reason')
    end

    it 'does not allow rejection if club is accepted' do
      expect(subject.valid?).to be(true)

      subject.accepted_at = Time.current
      subject.rejected_at = Time.current

      expect(subject.valid?).to eq(false)
    end

    it 'should be valid if all rejected fields are set' do
      subject.rejected_at = Time.current
      subject.rejected_reason = :other
      subject.rejected_notes = 'Example rejection reason.'
      expect(subject.valid?).to eq(true)
    end
  end

  describe 'accepted fields' do
    subject { create(:submitted_new_club_application) }

    it 'requires that submitted_at to be set if accepted_at is' do
      subject = create(:completed_new_club_application)
      expect(subject.submitted_at).to be(nil)

      subject.accepted_at = Time.current

      expect(subject.valid?).to be(false)
      expect(subject.errors).to include('submitted_at')
    end

    it 'requires that new_club be set if accepted_at is' do
      expect(subject.valid?).to be(true)

      subject.accepted_at = Time.current

      expect(subject.valid?).to be(false)
      expect(subject.errors).to include('new_club')
    end

    it 'requires that accepted_at to be set if new_club is' do
      expect(subject.valid?).to be(true)

      subject.new_club = create(:new_club)

      expect(subject.valid?).to be(false)
      expect(subject.errors).to include('accepted_at')
    end

    it 'does not allow acceptance if club is rejected' do
      expect(subject.valid?).to be(true)

      subject.rejected_at = Time.current
      subject.accepted_at = Time.current

      expect(subject.valid?).to be(false)
      expect(subject.errors).to include('rejected_at')
    end
  end

  describe ':submit!' do
    subject { create(:completed_new_club_application, profile_count: 3) }
    let(:user) { subject.point_of_contact }
    let(:profile) do
      LeaderProfile.find_by(user: user,
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

    it 'fails when leader profiles are not complete' do
      profile.update_attributes(leader_name: nil)
      res = subject.submit!

      expect(res).to eq(false)
      expect(subject.submitted_at).to be_nil
      expect(subject.errors[:base]).to include(
        'leader profiles not complete'
      )
    end

    it 'fails if already submitted' do
      # submit twice
      subject.submit!
      res = subject.submit!

      expect(res).to eq(false)
      expect(subject.errors[:base]).to include 'already submitted'
    end

    it 'succeeds when required fields are set & leader profiles complete' do
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

    it 'sends confirmation emails to applicants and staff' do
      perform_enqueued_jobs { subject.submit! }

      # three emails to applicants and two to staff (regular & JSON)
      expect(ApplicantMailer.deliveries.length).to eq(3 + 2)
    end
  end

  describe ':submitted?' do
    subject { create(:completed_new_club_application) }

    it 'return false when not submitted' do
      expect(subject.submitted?).to eq(false)
    end

    it 'returns true when submitted' do
      subject.submit!
      expect(subject.submitted?).to eq(true)
    end
  end

  describe ':interviewed?' do
    it 'returns false' do
      expect(subject.interviewed?).to eq(false)
    end

    context 'after interview fields are set' do
      subject { create(:interviewed_new_club_application) }

      it 'returns true' do
        expect(subject.interviewed?).to eq(true)
      end
    end
  end

  describe ':accept!' do
    subject { create(:submitted_new_club_application) }

    it 'fails when already accepted' do
      subject.accept!
      res = subject.accept!

      expect(res).to eq(false)
      expect(subject.errors[:base]).to include('already accepted')
    end

    it 'succeeds' do
      res = subject.accept!

      expect(res).to eq(true)
      expect(subject.accepted_at).to be_within(1.minute).of(Time.current)
      expect(subject.new_club).to_not be_nil

      # tests for club creation from existing applications are in specs for
      # NewClub
    end
  end

  describe ':accepted?' do
    subject { create(:submitted_new_club_application) }

    it 'returns false when not accepted' do
      expect(subject.accepted?).to eq(false)
    end

    it 'returns true when accepted' do
      subject.accepted_at = Time.current
      expect(subject.accepted?).to eq(true)
    end
  end
end
