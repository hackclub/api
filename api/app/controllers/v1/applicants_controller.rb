class V1::ApplicantsController < ApplicationController
  def auth
    applicant = Applicant.find_or_initialize_by(email: params[:email])

    applicant.generate_login_code

    if applicant.save
      ApplicantMailer.login_code(applicant).deliver_later

      render json: applicant, status: 200
    else
      render json: { errors: applicant.errors }, status: 422
    end
  end
end
