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

    def sms_auth
      user = User.find_by(email: params[:email].downcase)
      return render_not_found unless user
      return render_field_error(:phone_number, 'no phone number provided') unless user.phone_number

      begin
        ::TwilioVerificationService.new.send_verification_request(user.phone_number)
        render_success(
          id: user.id,
          email: user.email,
          status: 'login code sent'
        )
      rescue Twilio::REST::RestError => e
        return render_error('invalid phone number', 400) if e.code == 60_200
        return render_error('too many attempts', 429) if e.code == 60_203
        raise e
      end
    end

    def sms_exchange_login_code
      err = -> { render_field_error(:login_code, 'invalid', 401) }

      user = User.find(params[:user_id])
      login_code = params[:login_code]

      return render_not_found unless user
      return err.call if login_code.nil?

      begin
        return err.call unless ::TwilioVerificationService.new.check_verification_token(user.phone_number, login_code)
      rescue Twilio::REST::RestError => e
        return render_error('invalid code, please request another one', 400) if e.code == 20_404
        raise e
      end

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
        :email_on_new_challenge_post_comments,
        :phone_number
      )
    end
  end
end
