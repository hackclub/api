class V1::Cloud9Controller < ApplicationController
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def send_invite
    email = params[:email]
    errors = {}
    status = 200

    unless EMAIL_REGEX.match(email)
      errors['email'] = 'Must be a valid email'
      status = 422
    else
      begin
        Cloud9Client::Team.invite_member(
          Rails.application.secrets.cloud9_team_name,
          email
        )
      rescue RestClient::Conflict
        errors['email'] = 'Invite already sent for this email'
        status = 409
      end
    end

    if errors.size > 0
      render json: { errors: errors }, status: status
    else
      render json: { success: true }, status: status
    end
  end
end
