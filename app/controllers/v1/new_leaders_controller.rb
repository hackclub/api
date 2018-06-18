# frozen_string_literal: true

module V1
  class NewLeadersController < ApiController
    include UserAuth

    def show
      leader = NewLeader.find(params[:id])
      authorize leader

      render_success leader
    end

    def update
      leader = NewLeader.find(params[:id])
      authorize leader

      if leader.update_attributes(leader_params)
        render_success leader
      else
        render_field_errors leader.errors
      end
    end

    private

    def leader_params
      params.permit(
        :name,
        :email,
        :birthday,
        :expected_graduation,
        :gender,
        :ethnicity,
        :phone_number,
        :address,
        :personal_website,
        :github_url,
        :linkedin_url,
        :facebook_url,
        :twitter_url
      )
    end
  end
end
