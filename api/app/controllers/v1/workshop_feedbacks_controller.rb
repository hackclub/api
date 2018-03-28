# frozen_string_literal: true

module V1
  class WorkshopFeedbacksController < ApiController
    def create
      feedback = WorkshopFeedback.new(
        workshop_slug: params[:workshop_slug],
        feedback: params[:feedback],
        ip_address: request.ip
      )

      if feedback.save
        render_success feedback, 201
      else
        render_field_errors feedback.errors
      end
    end
  end
end
