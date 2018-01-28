# frozen_string_literal: true

module V1
  class UsersController < ApiController
    def auth
      user = User.find_or_initialize_by(email: params[:email])

      user.generate_login_code!

      if user.save
        ApplicantMailer.login_code(user).deliver_later

        render_success(user)
      else
        render_field_errors(user.errors)
      end
    end

    def exchange_login_code
      user = User.find_by(id: params[:user_id])
      login_code = params[:login_code]

      return render_not_found unless user

      if !login_code.nil? &&
         user.login_code == login_code &&
         user.login_code_generation > (Time.current - 15.minutes)

        user.generate_auth_token!
        user.login_code = nil
        user.login_code_generation = nil
        user.save

        return render_success(auth_token: user.auth_token)
      end

      render_field_error(:login_code, 'invalid', 401)
    end
  end
end
