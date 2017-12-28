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

  def exchange_login_code
    applicant = Applicant.find_by(login_code: params[:login_code])

    if applicant && applicant.login_code_generation > (Time.now - 1.hour)
      applicant.generate_auth_token
      applicant.login_code = nil
      applicant.login_code_generation = nil
      applicant.save

      render json: { auth_token: applicant.auth_token }, status: 200
    else
      render json: { errors: { login_code: 'invalid' } }, status: 401
    end
  end
end
