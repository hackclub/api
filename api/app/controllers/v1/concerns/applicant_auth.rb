# this is tested in spec/controllers/v1/concerns/
module ApplicantAuth
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_applicant
  end

  def authenticate_applicant
    auth_header = request.headers['Authorization']

    unless auth_header
      render json: { error: 'authorization required' }, status: 401
      return
    end

    auth_type, auth_token = auth_header.split(' ')

    unless auth_token
      render json: { error: 'authorization invalid' }, status: 401
      return
    end

    @applicant = Applicant.find_by(auth_token: auth_token)

    if @applicant
      unless @applicant.auth_token_generation > (Time.current - 1.day)
        render json: { error: 'auth token expired' }, status: 401
      end
    else
      render json: { error: 'authorization invalid' }, status: 401
    end
  end
end
