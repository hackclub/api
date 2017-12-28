require "rails_helper"

RSpec.describe ApplicantMailer, type: :mailer do
  describe 'login_code' do
    let(:applicant) do
      applicant = create(:applicant)
      applicant.generate_login_code
      applicant.save

      applicant
    end

    let(:mail) { ApplicantMailer.login_code(applicant) }

    it 'is sent to the applicant' do
      expect(mail).to deliver_to(applicant.email)
    end

    it 'contains the given login code' do
      expect(mail).to have_body_text(applicant.login_code)
    end
  end
end
