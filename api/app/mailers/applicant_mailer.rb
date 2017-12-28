class ApplicantMailer < ApplicationMailer
  def login_code(applicant)
    @login_code = applicant.login_code

    mail(to: applicant.email, subject: "Hack Club Login Code #{@login_code}")
  end
end
