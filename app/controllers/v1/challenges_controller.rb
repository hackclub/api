# frozen_string_literal: true

module V1
  class ChallengesController < ApiController
    USER_AUTH = { except: %i[index show] }.freeze
    include UserAuth

    def index
      render_success Challenge.all
    end

    def create
      challenge = Challenge.new(challenge_params)
      challenge.creator = current_user

      authorize challenge

      if challenge.save
        render_success challenge, 201
      else
        render_field_errors challenge.errors
      end
    end

    def show
      render_success Challenge.find(params[:id])
    end

    private

    def challenge_params
      params.permit(
        :name,
        :description,
        :start,
        :end
      )
    end
  end
end
