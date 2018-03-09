# frozen_string_literal: true

module V1
  class EventsController < ApiController
    def index
      render_success Event.all
    end
  end
end
