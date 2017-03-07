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

          handle_event
        end
      end

      def handle_event
        event = params[:event].to_unsafe_h
        team_id = params[:team_id]

        HandleSlackEventJob.perform_later(event, team_id)
      end
    end
  end
end
