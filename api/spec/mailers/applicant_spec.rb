# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicantMailer, type: :mailer do
  describe 'login_code' do
    let(:applicant) do
      applicant = create(:applicant)
      applicant.generate_login_code!
      applicant.save

      applicant
    end

    let(:mail) { ApplicantMailer.login_code(applicant) }

    it 'is sent to the applicant' do
      expect(mail).to deliver_to(applicant.email)
    end

    it 'contains the given prettified login code' do
      expect(mail).to have_body_text(applicant.pretty_login_code)
    end
  end

  describe 'added_to_application' do
    let(:adder) { create(:applicant) }
    let(:applicant) { create(:applicant) }
    let(:club_application) { create(:new_club_application) }

    before do
      club_application.applicants << adder
      club_application.applicants << applicant
    end

    let(:mail) do
      ApplicantMailer.added_to_application(club_application, applicant, adder)
    end

    it 'is sent to the given applicant' do
      expect(mail).to deliver_to(applicant.email)
    end

    it 'includes the high school name when set' do
      club_application.high_school_name = 'Superhero High School'

      expect(mail).to have_body_text('Superhero High School')
    end

    it "includes the adder's email" do
      expect(mail).to have_body_text(adder.email)
    end

    it "includes the given applicant's email" do
      expect(mail).to have_body_text(applicant.email)
    end
  end

  describe 'application_submission' do
    let(:application) { create(:completed_new_club_application) }
    let(:applicant) { application.applicants.first }

    before { application.submit! }

    let(:mail) do
      ApplicantMailer.application_submission(application, applicant)
    end

    it 'is sent to the given applicant' do
      expect(mail).to deliver_to(applicant.email)
    end

    it 'includes fields from the application' do
      expect(mail).to have_body_text(application.progress_general)
    end

    it "includes fields from the applicant's profile" do
      profile = ApplicantProfile.find_by(applicant: applicant,
                                         new_club_application: application)
      expect(mail).to have_body_text(profile.skills_system_hacked)
    end
  end
end
