module V1
  module Hackbot
    class WebhookController < ApplicationController
      def callback
        # See https://api.slack.com/events/url_verification
        if params[:type] == 'url_verification'
          render plain: params[:challenge]
        elsif params[:type] != 'event_callback'
          render status: :not_implemented
        else
          render status: 200

          #Thread.new { handle_message }
          handle_message
        end
      end

      private

      def handle_message
        slack_team = ::Hackbot::Team.find_by(team_id: params[:team_id])
        ::Hackbot::Dispatcher.new.handle(params[:event], slack_team)
      end
    end
  end
end
