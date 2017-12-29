# Preview all emails at http://localhost:3000/rails/mailers/applicant
class ApplicantPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/applicant/login_code
  def login_code
    applicant = FactoryBot.create(:applicant)
    applicant.generate_login_code && applicant.save

    ApplicantMailer.login_code(applicant)
  end
end
