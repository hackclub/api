# frozen_string_literal: true

# this is tested in spec/controllers/v1/concerns/
module ApplicantAuth
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_applicant
  end

  def authenticate_applicant
    auth_header = request.headers['Authorization']
    return render_unauthenticated unless auth_header

    _auth_type, auth_token = auth_header.split(' ')
    return render_invalid_authorization unless auth_token

    @applicant = Applicant.find_by(auth_token: auth_token)

    if @applicant
      unless @applicant.auth_token_generation > (Time.current - 1.day)
        return render_error('auth token expired', 401)
      end

      # all clear! authed & ready to go.
    else
      render_invalid_authorization
    end
  end

  protected

  def render_unauthenticated
    render_error('authorization required', 401)
  end

  def render_invalid_authorization
    render_error('authorization invalid', 401)
  end
end
