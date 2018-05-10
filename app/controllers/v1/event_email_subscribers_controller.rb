# frozen_string_literal: true

module V1
  class EventEmailSubscribersController < ApiController
    def create
      existing_subscriber = EventEmailSubscriber.unsubscribed.find_by(
        email: subscriber_params[:email]
      )

      existing_subscriber.unsubscribed_at = nil if existing_subscriber

      subscriber = existing_subscriber || EventEmailSubscriber.new

      if subscriber.update_attributes(subscriber_params)
        EventEmailSubscriberMailer.confirm_email(subscriber).deliver_later

        if existing_subscriber
          render_success subscriber, 200
        else
          render_success subscriber, 201
        end
      else
        render_field_errors subscriber.errors
      end
    end

    def confirm
      token = params[:token]

      return render_field_error(:token, "can't be blank") unless token

      subscriber = EventEmailSubscriber.unconfirmed.find_by(
        confirmation_token: token
      )

      return render_not_found unless subscriber

      subscriber.update_attributes(confirmed_at: Time.current)

      render plain: 'Email confirmed! You will now receive notifications for '\
        "events added near #{subscriber.parsed_address}."
    end

    def unsubscribe
      token = params[:token]

      return render_field_error(:token, "can't be blank") unless token

      subscriber = EventEmailSubscriber.subscribed.find_by(
        unsubscribe_token: token
      )

      return render_not_found unless subscriber

      subscriber.update_attributes(unsubscribed_at: Time.current)

      # send confirmation email
      EventEmailSubscriberMailer.unsubscribe(subscriber).deliver_later

      render plain: "Successfully unsubscribed. If you'd like to re-subscribe "\
        'in the future, go ahead and fill out the form on '\
        'https://hackathons.hackclub.com.'
    end

    private

    def subscriber_params
      params.permit(:email, :location)
    end
  end
end
