# frozen_string_literal: true

module V1
  module EventEmailSubscribers
    class StatsController < ApiController
      def index
        render json: EventEmailSubscriber.stats
      end
    end
  end
end
