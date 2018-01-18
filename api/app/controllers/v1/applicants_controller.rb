# frozen_string_literal: true

module V1
  class ApplicantsController < ApiController
    def auth
      applicant = Applicant.find_or_initialize_by(email: params[:email])

      applicant.generate_login_code!

      if applicant.save
        # deliver_now to ensure email is sent as quickly as possible
        ApplicantMailer.login_code(applicant).deliver_now

        render_success(applicant)
      else
        render_field_errors(applicant.errors)
      end
    end

    def exchange_login_code
      applicant = Applicant.find_by(id: params[:applicant_id])
      login_code = params[:login_code]

      return render_not_found unless applicant

      if !login_code.nil? &&
         applicant.login_code == login_code &&
         applicant.login_code_generation > (Time.current - 15.minutes)

        applicant.generate_auth_token!
        applicant.login_code = nil
        applicant.login_code_generation = nil
        applicant.save

        return render_success(auth_token: applicant.auth_token)
      end

      render_field_error(:login_code, 'invalid', 401)
    end
  end
end
