# frozen_string_literal: true

module V1
  class UsersController < ApiController
    USER_AUTH = { only: %i[index current show update auth_on_behalf] }.freeze
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

      code = user.login_codes.new(
        ip_address: request.ip,
        user_agent: request.user_agent
      )

      if user.save && code.save
        ApplicantMailer.login_code(code).deliver_later

        render_success(
          id: user.id,
          email: user.email,
          status: 'login code sent'
        )
      elsif !user.valid?
        render_field_errors user.errors
      elsif !code.valid?
        render_field_errors code.errors
      end
    end

    def exchange_login_code
      err = -> { render_field_error(:login_code, 'invalid', 401) }

      user = User.find_by(id: params[:user_id])
      login_code = params[:login_code]

      return render_not_found unless user
      return err.call if login_code.nil?

      found_code = user.login_codes.active.find_by(code: login_code)

      return err.call unless found_code
      return err.call unless found_code.created_at > (Time.current - 15.minutes)

      user.generate_auth_token!
      found_code.used_at = Time.current

      found_code.save! && user.save!

      render_success(auth_token: user.auth_token)
    end

    # Allows admins to create users and authenticate on their behalf.
    # Used by Hack Club Bank for pre-created organization users
    def auth_on_behalf
      return render_access_denied unless current_user.admin?

      user = User.find_or_initialize_by(email: params[:email].downcase)
      user.generate_auth_token!
      user.save!

      render_success(auth_token: user.auth_token)
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
        :email_on_new_challenges,
        :email_on_new_challenge_posts,
        :email_on_new_challenge_post_comments
      )
    end
  end
end
