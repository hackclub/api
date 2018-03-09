# frozen_string_literal: true

module V1
  class EventsController < ApiController
    USER_AUTH = { except: [:index] }.freeze
    include UserAuth

    def index
      render_success Event.all
    end

    def create
      event = Event.new(event_params)
      authorize event

      if event.save
        render_success event, 201
      else
        render_field_errors event.errors
      end
    end

    private

    def event_params
      params.permit(
        :start,
        :end,
        :name,
        :website,
        :total_attendance,
        :first_time_hackathon_estimate,
        :address
      )
    end
  end
end
