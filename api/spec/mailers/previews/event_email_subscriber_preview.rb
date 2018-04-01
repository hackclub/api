# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/event_email_subscriber
class EventEmailSubscriberPreview < ActionMailer::Preview
  def confirm_email
    subscriber = FactoryBot.create(:event_email_subscriber)

    EventEmailSubscriberMailer.confirm_email(subscriber)
  end

  def new_event
    subscriber = FactoryBot.create(:event_email_subscriber_confirmed)
    event = FactoryBot.create(
      :event,
      parsed_city: 'Chicago',
      parsed_state: 'IL'
    )

    EventEmailSubscriberMailer.new_event(subscriber, event)
  end

  def unsubscribe
    subscriber = FactoryBot.create(:event_email_subscriber_unsubscribed)

    EventEmailSubscriberMailer.unsubscribe(subscriber)
  end
end
