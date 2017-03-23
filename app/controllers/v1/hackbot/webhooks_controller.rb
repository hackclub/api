module V1
  module Hackbot
    class WebhooksController < ApplicationController
      def interactive_messages
        payload = JSON.parse(params[:payload], symbolize_names: true)
        event = action_payload_to_event(payload)

        handle_event(event, event[:team_id])

        sleep 1
      end

      def events
        case params[:type]
        when 'url_verification' # See https://api.slack.com/events/url_verification
          render plain: params[:challenge]
        when 'event_callback'
          render status: 200

          event = params[:event].to_unsafe_h

          handle_event(event, params[:team_id])
        else
          render status: :not_implemented
        end
      end

      private

      def handle_event(event, team_id)
        HandleSlackEventJob.perform_later(event, team_id)
      end

      def action_payload_to_event(payload)
        { type: 'action',
          channel: payload[:channel][:id],
          team_id: payload[:team][:id],
          user: payload[:user][:id],
          ts: payload[:action_ts],
          action: resolve_action(payload[:actions].first,
                                 payload[:original_message][:attachments]),
          msg: payload[:original_message],
          response_url: payload[:response_url] }
      end

      # Given an action from payload[:actions], find its corresponding source
      # action in a list of Slack attachments.
      #
      # Actions in payload[:actions] don't have all of the attributes that their
      # source actions have, including the action text.
      def resolve_action(action, attachments)
        attachments.each do |attachment|
          next unless attachment[:actions].is_a? Enumerable

          attachment[:actions].each do |a|
            return a if a[:name] == action[:name] &&
                        a[:type] == action[:type] &&
                        a[:value] == action[:value]
          end
        end
      end
    end
  end
end
