# frozen_string_literal: true

module V1
  class EventWebsiteClicksController < ApiController
    def create
      event = Event.find(params[:event_id])
      subscriber = EventEmailSubscriber.find_by(
        link_tracking_token: params[:token]
      )

      EventWebsiteClick.create!(
        event: event,
        email_subscriber: subscriber,
        ip_address: request.ip,
        user_agent: request.user_agent,
        referer: request.referer
      )

      redirect_to event.website
    end
  end
end
