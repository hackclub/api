# frozen_string_literal: true
class ApplicantMailer < ApplicationMailer
  def login_code(applicant)
    @login_code = applicant.pretty_login_code

    mail(to: applicant.email, subject: "Hack Club Login Code (#{@login_code})")
  end

  def added_to_application(application, applicant, adder)
    @high_school = application.high_school_name
    @applicant_email = applicant.email
    @adder_email = adder.email

    mail(to: applicant.email,
         subject: "You've been added to a Hack Club application")
  end

  def application_submission(application, applicant)
    @application = application

    mail(to: applicant.email, subject: 'Hack Club Application Submitted')
  end
end
