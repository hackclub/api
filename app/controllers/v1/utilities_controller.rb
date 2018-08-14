# frozen_string_literal: true

module V1
  class UtilitiesController < ApiController
    def new_leader_exists
      email = params[:email]
      leader = NewLeader.find_by(email: email)

      render_success(exists: leader.present?)
    end
  end
end
