# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendEventNotificationEmailsJob, type: :job do
  let(:event) do
    create(
      :event,
      address: 'Chicago, IL',
      latitude: 41.7373598,
      longitude: -87.7213231
    )
  end

  context 'with nearby subscribers' do
    before do
      # 2 people confirmed far away
      2.times do
        create(
          :event_email_subscriber_confirmed,
          location: 'Los Angeles, CA',
          latitude: 34.0522,
          longitude: -118.2437
        )
      end

      # 3 people unconfirmed close by
      3.times do
        create(
          :event_email_subscriber,
          location: 'Chicago, IL',
          latitude: event.latitude,
          longitude: event.longitude
        )
      end

      # 5 people confirmed close by
      5.times do
        create(
          :event_email_subscriber_confirmed,
          location: 'Chicago, IL',
          latitude: event.latitude,
          longitude: event.longitude
        )
      end

      # 4 people unsubscribed close by
      4.times do
        create(
          :event_email_subscriber_unsubscribed,
          location: 'Chicago, IL',
          latitude: event.latitude,
          longitude: event.longitude
        )
      end
    end

    it 'queues notification emails' do
      expect(EventEmailSubscriberMailer.deliveries.length).to eq(0)

      perform_enqueued_jobs do
        SendEventNotificationEmailsJob.perform_now(event.id)
      end

      # only sends to the 5 confirmed nearby
      expect(EventEmailSubscriberMailer.deliveries.length).to eq(5)
    end
  end

  # this might happen if an admin creates a new event and then later deletes it
  # before the job is ran
  context 'when event is deleted' do
    before { event.destroy }

    it 'handles gracefully' do # no exceptions are thrown
      SendEventNotificationEmailsJob.perform_now(event.id)
    end
  end
end
