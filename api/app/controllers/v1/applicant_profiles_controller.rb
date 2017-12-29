class V1::ApplicantProfilesController < ApplicationController
  include ApplicantAuth

  def show
    profile = ApplicantProfile.find_by(id: params[:id])

    return render json: { error: 'not found' }, status: 404 unless profile

    if profile.applicant != @applicant
      return render json: { error: 'access denied' }, status: 403
    end

    render json: profile, status: 200
  end

  def update
    profile = ApplicantProfile.find_by(id: params[:id])

    return render json: { error: 'not found' }, status: 404 unless profile

    if profile.applicant != @applicant
      return render json: { error: 'access denied' }, status: 403
    end

    profile.update_attributes(applicant_profile_params)

    render json: profile, status: 200
  end

  private

  def applicant_profile_params
    params.permit(
      :leader_name,
      :leader_email,
      :leader_age,
      :leader_year_in_school,
      :leader_gender,
      :leader_ethnicity,
      :leader_phone_number,
      :leader_address,
      :leader_latitude,
      :leader_longitude,
      :leader_parsed_address,
      :leader_parsed_city,
      :leader_parsed_state,
      :leader_parsed_state_code,
      :leader_parsed_postal_code,
      :leader_parsed_country,
      :leader_parsed_country_code,
      :presence_personal_website,
      :presence_github_url,
      :presence_linkedin_url,
      :presence_facebook_url,
      :presence_twitter_url,
      :skills_system_hacked,
      :skills_impressive_achievement,
      :skills_is_technical
    )
  end
end
