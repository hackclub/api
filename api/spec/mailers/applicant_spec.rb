# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicantMailer, type: :mailer do
  describe 'login_code' do
    let(:user) do
      user = create(:user)
      user.generate_login_code!
      user.save

      user
    end

    let(:mail) { ApplicantMailer.login_code(user) }

    it 'is from team@hackclub.com' do
      expect(mail).to deliver_from('Hack Club Team <team@hackclub.com>')
    end

    it 'is sent to the user' do
      expect(mail).to deliver_to(user.email)
    end

    it 'contains the given prettified login code' do
      expect(mail).to have_body_text(user.pretty_login_code)
    end
  end

  describe 'added_to_application' do
    let(:adder) { create(:user) }
    let(:user) { create(:user) }
    let(:club_application) { create(:new_club_application) }

    before do
      club_application.users << adder
      club_application.users << user
    end

    let(:mail) do
      ApplicantMailer.added_to_application(club_application, user, adder)
    end

    it 'is sent to the given user' do
      expect(mail).to deliver_to(user.email)
    end

    it 'includes the high school name when set' do
      club_application.high_school_name = 'Superhero High School'

      expect(mail).to have_body_text('Superhero High School')
    end

    it "includes the adder's email" do
      expect(mail).to have_body_text(adder.email)
    end

    it "includes the given user's email" do
      expect(mail).to have_body_text(user.email)
    end
  end

  describe 'application_submission' do
    let(:application) { create(:completed_new_club_application) }
    let(:user) { application.users.first }

    before { application.submit! }

    let(:mail) do
      ApplicantMailer.application_submission(application, user)
    end

    it 'is sent to the given user' do
      expect(mail).to deliver_to(user.email)
    end

    it 'includes fields from the application' do
      expect(mail).to have_body_text(application.progress_general)
    end

    it "includes fields from the user's leader profile" do
      profile = LeaderProfile.find_by(user: user,
                                      new_club_application: application)
      expect(mail).to have_body_text(profile.skills_system_hacked)
    end
  end
end
