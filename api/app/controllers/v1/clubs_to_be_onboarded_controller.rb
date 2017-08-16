module V1
  class ClubsToBeOnboardedController < ApplicationController
    TO_BE_ONBOARDED_STAGE = '5001'.freeze

    def show
      render json: Club.select { |c| c.stage_key == TO_BE_ONBOARDED_STAGE }
    end
  end
end
