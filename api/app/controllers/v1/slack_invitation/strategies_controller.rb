# frozen_string_literal: true

module V1
  module SlackInvitation
    class StrategiesController < ApiController
      def show
        @strat = SlackInviteStrategy.find_by(name: params[:id])
        return render_not_found unless @strat

        render_success(@strat)
      end
    end
  end
end
