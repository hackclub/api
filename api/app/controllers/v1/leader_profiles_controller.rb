# frozen_string_literal: true

module V1
  class LeaderProfilesController < ApiController
    include UserAuth

    def show
      profile = LeaderProfile.find(params[:id])
      authorize profile

      render_success(profile)
    end

    def update
      profile = LeaderProfile.find(params[:id])
      authorize profile

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
