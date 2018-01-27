# frozen_string_literal: true

module V1
  class LeaderProfilesController < ApiController
    include UserAuth

    def show
      profile = LeaderProfile.find_by(id: params[:id])

      return render_not_found unless profile
      return render_access_denied if profile.user != @user

      render_success(profile)
    end

    def update
      profile = LeaderProfile.find_by(id: params[:id])

      return render_not_found unless profile
      return render_access_denied if profile.user != @user

      if profile.submitted_at.present?
        return render_field_error(
          :base, 'cannot edit leader profile after submit'
        )
      end

      # TODO: Check for errors and return them if needed
      profile.update_attributes(leader_profile_params)

      render_success(profile)
    end

    private

    def leader_profile_params
      params.permit(
        :leader_name,
        :leader_email,
        :leader_birthday,
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
end
