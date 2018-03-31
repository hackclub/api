# frozen_string_literal: true

class SendEventNotificationEmailsJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    e = Event.find_by(id: event_id)

    # if it can't find the event, fail gracefully -- this may happen if an admin
    # creates an event and later deletes it before this job is ran. handling
    # this case to give admins as much flexibility as possible.
    return if e.nil?

    EventEmailSubscriber
      .subscribed
      .near([e.latitude, e.longitude], 0.5)
      .find_each do |subscriber|
      EventEmailSubscriberMailer.new_event(subscriber, e).deliver_later
    end
  end
end
