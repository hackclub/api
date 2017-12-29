class V1::ApplicantsController < ApplicationController
  def auth
    applicant = Applicant.find_or_initialize_by(email: params[:email])

    applicant.generate_login_code!

    if applicant.save
      ApplicantMailer.login_code(applicant).deliver_later

      render json: applicant, status: 200
    else
      render json: { errors: applicant.errors }, status: 422
    end
  end

  def exchange_login_code
    applicant = Applicant.find_by(id: params[:applicant_id])
    login_code = params[:login_code]

    unless applicant
      return render json: { error: 'not found' }, status: 404
    end

    if login_code != nil &&
        applicant.login_code == login_code &&
        applicant.login_code_generation > (Time.now - 15.minutes)

      applicant.generate_auth_token!
      applicant.login_code = nil
      applicant.login_code_generation = nil
      applicant.save

      return render json: { auth_token: applicant.auth_token }, status: 200
    end

    render json: { errors: { login_code: 'invalid' } }, status: 401
  end
end
