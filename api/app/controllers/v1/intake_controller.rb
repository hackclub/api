module V1
  class IntakeController < ApplicationController
    def show
      render json: Club.all.reject(&:dead?)
    end
  end
end
