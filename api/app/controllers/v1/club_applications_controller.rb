module V1
  class ClubApplicationsController < ApplicationController
    def create
      application = ClubApplication.new(application_params)

      if application.save
        render json: application, status: 201
      else
        render json: { errors: application.errors }, status: 422
      end
    end

    def application_params
      params.permit(
        :first_name, :last_name, :email, :github, :twitter, :high_school,
        :interesting_project, :systems_hacked, :steps_taken, :year, :referer,
        :phone_number, :start_date
      )
    end
  end
end
