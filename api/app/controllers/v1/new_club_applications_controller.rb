class V1::NewClubApplicationsController < ApplicationController
  before_action :authenticate_applicant

  def index
    render json: @applicant.new_club_applications, status: 200
  end

  def create
    c = NewClubApplication.create(applicants: [@applicant])

    render json: c, status: 201
  end

  def update
    c = NewClubApplication.find(params[:id])

    unless c.applicants.include? @applicant
      return render json: { error: 'access denied' }, status: 403
    end

    if c.update_attributes(club_application_params)
      render json: c, status: 200
    else
      # this should never be hit
      render json: { error: 'internal server error' }, status: 500
    end
  end

  private

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

    unless @applicant
      render json: { error: 'authorization invalid' }, status: 401
    end
  end

  def club_application_params
    params.permit(
      :high_school_name,
      :high_school_url,
      :high_school_type,
      :high_school_address,
      :leaders_video_url,
      :leaders_interesting_project,
      :leaders_team_origin_story,
      :progress_general,
      :progress_student_interest,
      :progress_meeting_yet,
      :idea_why,
      :idea_other_coding_clubs,
      :idea_other_general_clubs,
      :formation_registered,
      :formation_misc,
      :curious_what_convinced,
      :curious_how_did_hear
    )
  end
end
