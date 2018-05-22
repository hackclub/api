# frozen_string_literal: true

module V1
  module Users
    class NewLeadersController < ApiController
      include UserAuth

      def create
        user = User.find(params[:user_id])
        unless current_user.admin? || user == current_user
          return render_unauthorized
        end

        if user.new_leader
          return render_field_error(
            :base,
            'user already has a new_leader associated',
            409
          )
        end

        user.new_leader = NewLeader.new(leader_params)

        if user.new_leader.save
          render_success user.new_leader, 201
        else
          render_field_errors user.new_leader.errors
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
end
