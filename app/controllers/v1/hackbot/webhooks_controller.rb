module V1
  module Hackbot
    class WebhooksController < ApplicationController
      def interactions
        payload = JSON.parse(params[:payload], symbolize_names: true)
        event = interaction_payload_to_event(payload)

        handle_event(event, event[:team_id])

        sleep 1
      end

      def events
        # See https://api.slack.com/events/url_verification
        if params[:type] == 'url_verification'
          render plain: params[:challenge]
        elsif params[:type] != 'event_callback'
          render status: :not_implemented
        else
          render status: 200

          event = params[:event].to_unsafe_h

          handle_event(event, params[:team_id])
        end
      end

      private

      def handle_event(event, team_id)
        HandleSlackEventJob.perform_later(event, team_id)
      end

      def interaction_payload_to_event(payload)
        {
          type: 'action',
          channel: payload[:channel][:id],
          team_id: payload[:team][:id],
          user: payload[:user][:id],
          ts: payload[:action_ts],
          action: payload[:actions].first,
          msg: payload[:original_message],
          response_url: payload[:response_url]
        }
      end
    end
  end
end
