module V1
  module SlackInvitation
    class StrategiesController < ApplicationController
      def show
        @strat = SlackInviteStrategy.find_by(name: params[:id])

        unless @strat
          render json: {}, status: 404

          return
        end

        render json: @strat
      end
    end
  end
end
