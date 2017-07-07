class ClubApplicationMailer < ApplicationMailer
  default from: 'Hack Club Team <team@hackclub.com>'

  def application_confirmation(application)
    @application = application

    to = Mail::Address.new @application.email
    to.display_name = @application.full_name

    mail(to: to.format, subject: 'Application Confirmation')
  end

  def admin_notification(application)
    @application = application

    to = Mail::Address.new 'team@hackclub.com'
    to.display_name = 'Hack Club Team'

    mail(to: to.format, subject: @application.high_school)
  end
end
