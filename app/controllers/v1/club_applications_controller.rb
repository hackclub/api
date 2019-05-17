# frozen_string_literal: true

module V1
  class ClubApplicationsController < ApiController
    def create
      application = ClubApplication.new(application_params)

      if application.save
        render_success(application, 201)

        ClubApplicationMailer.application_confirmation(application).deliver
        ClubApplicationMailer.admin_notification(application).deliver
      else
        render_field_errors(application.errors)
      end
    end

    private

    def application_params
      params.require(:club_application).permit(
        :first_name, :last_name, :email, :github, :twitter, :high_school,
        :interesting_project, :systems_hacked, :steps_taken, :year, :referer,
        :phone_number, :start_date
      )
    end
  end
end
