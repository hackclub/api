class V1::NewClubApplicationsController < ApplicationController
  before_action :authenticate_applicant

  def index
    if params[:applicant_id] == @applicant.id.to_s
      render json: @applicant.new_club_applications, status: 200
    else
      render json: { error: 'access denied' }, status: 403
    end
  end

  def show
    application = NewClubApplication.find_by(id: params[:id])

    unless application
      return render json: { error: 'not found' }, status: 404
    end

    if application.applicants.include? @applicant
      render json: application, status: 200
    else
      render json: { error: 'access denied' }, status: 403
    end
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

  def add_applicant
    app = NewClubApplication.find_by(id: params[:new_club_application_id])

    unless app
      return render json: { error: 'not found' }, status: 404
    end

    unless app.applicants.include? @applicant
      return render json: { error: 'access denied' }, status: 403
    end

    to_add = Applicant.find_or_create_by(email: params[:email])

    if app.applicants.include? to_add
      return render json: { errors: { email: ['already added'] } }, status: 422
    end

    app.applicants << to_add

    ApplicantMailer.added_to_application(app, to_add, @applicant).deliver_later

    render json: { success: true }, status: 200
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

    if @applicant
      unless @applicant.auth_token_generation > (Time.current - 1.day)
        render json: { error: 'auth token expired' }, status: 401
      end
    else
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
      :other_surprising_or_amusing_discovery,
      :curious_what_convinced,
      :curious_how_did_hear
    )
  end
end
