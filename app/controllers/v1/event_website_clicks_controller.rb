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

      redirect_to add_params_to_url(event.website, ref: 'hackclub')
    end

    private

    # code in here based on https://stackoverflow.com/a/26867426
    def add_params_to_url(url, params)
      uri = URI.parse(url)
      new_query_ar = URI.decode_www_form(uri.query || '')
      params.each { |k, v| new_query_ar << [k, v] }
      uri.query = URI.encode_www_form(new_query_ar)
      uri.to_s
    end
  end
end
