# frozen_string_literal: true

module V1
  class ClubsToBeOnboardedController < ApiController
    TO_BE_ONBOARDED_STAGE = '5011'

    def show
      render_success Club.select { |c| c.stage_key == TO_BE_ONBOARDED_STAGE }
    end
  end
end
