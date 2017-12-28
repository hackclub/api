class V1::NewClubApplicationsController < ApplicationController
  before_action :authenticate_applicant, only: :index

  def index
    render json: @applicant.new_club_applications, status: 200
  end

  private

  def authenticate_applicant
    auth_header = request.headers['Authorization']

    unless auth_header
      render json: { error: 'authorization is required' }, status: 401
      return
    end

    auth_type, auth_token = auth_header.split(' ')

    unless auth_token
      render json: { error: 'authorization is invalid' }, status: 401
      return
    end

    @applicant = Applicant.find_by(auth_token: auth_token)

    unless @applicant
      render json: { error: 'authorization is invalid' }, status: 401
    end
  end
end
