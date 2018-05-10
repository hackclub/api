# frozen_string_literal: true

module V1
  class IntakeController < ApiController
    def show
      render_success Club.all.reject(&:dead?)
    end
  end
end
