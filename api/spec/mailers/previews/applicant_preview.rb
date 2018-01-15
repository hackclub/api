# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/applicant
class ApplicantPreview < ActionMailer::Preview
  def login_code
    applicant = FactoryBot.create(:applicant)
    applicant.generate_login_code && applicant.save

    ApplicantMailer.login_code(applicant)
  end

  def application_submission
    application = FactoryBot.create(:completed_new_club_application)
    application.submit!

    ApplicantMailer.application_submission(application,
                                           application.applicants.first)
  end

  def application_submission_staff
    application = FactoryBot.create(:completed_new_club_application)
    application.submit!

    ApplicantMailer.application_submission_staff(application)
  end
end
