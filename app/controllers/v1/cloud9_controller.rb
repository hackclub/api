module V1
  class Cloud9Controller < ApplicationController
    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    def send_invite
      unless EMAIL_REGEX.match(email)
        return render json: { errors: { email: 'Must be a valid email' } },
                      status: 422
      end

      invite_member(email)

      render json: { success: true }
    rescue RestClient::Conflict
      render json: { errors: { email: 'Invite already sent for this email' } },
             status: 409
    end

    protected

    def invite_member(email)
      Cloud9Client::Team.invite_member(
        Rails.application.secrets.cloud9_team_name,
        email
      )
    end

    def email
      params[:email]
    end
  end
end
