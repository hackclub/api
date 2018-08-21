# frozen_string_literal: true

class EventEmailSubscriberMailer < ApplicationMailer
  default from: 'Hack Club Hackathons <hackathons@hackclub.com>'

  def confirm_email(subscriber)
    @subscriber = subscriber

    mail to: subscriber.email,
         subject: 'Action Requested: Confirm Your Email'
  end

  def new_event(subscriber, new_event)
    @subscriber = subscriber
    @event = new_event

    mail to: subscriber.email,
         subject: 'New event near you: ' + @event.name
  end

  def unsubscribe(subscriber)
    @subscriber = subscriber
    mail to: subscriber.email, subject: 'Unsubscription Confirmation'
  end
end
