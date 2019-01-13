# frozen_string_literal: true

module V1
  class UsersController < ApiController
    USER_AUTH = { only: %i[index current show update] }.freeze
    include UserAuth

    def index
      return render_access_denied unless current_user.admin?

      if params[:email]
        render_success User.where('email LIKE ?', "%#{params[:email]}%")
      else
        render_success User.all
      end
    end

    def auth
      user = User.find_or_initialize_by(email: params[:email].downcase)

      user.generate_login_code!

      if user.save
        if user.sms?
          TwilioClient.send_login_code(user)
        elsif user.email?
          ApplicantMailer.login_code(user).deliver_later
        end

        render_success(
          id: user.id,
          email: user.email,
          status: 'login code sent'
        )
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

    def current
      render_success current_user
    end

    def show
      u = User.find(params[:id])
      authorize u

      render_success u
    end

    def update
      u = User.find(params[:id])
      authorize u

      if u.update_attributes(user_params)
        render_success u
      else
        render_field_errors u.errors
      end
    end

    private

    def user_params
      params.permit(
        :username,
        :phone_number,
        :auth_type,
        :email_on_new_challenges,
        :email_on_new_challenge_posts,
        :email_on_new_challenge_post_comments
      )
    end
  end
end
