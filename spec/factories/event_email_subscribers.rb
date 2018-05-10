# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :event_email_subscriber do
    email { Faker::Internet.email }
    location { "#{Faker::Address.city}, #{Faker::Address.state_abbr}" }

    factory :event_email_subscriber_confirmed do
      after(:create) do |subscriber|
        subscriber.confirmed_at = Time.current
        subscriber.save
      end
    end

    factory :event_email_subscriber_unsubscribed,
            parent: :event_email_subscriber_confirmed do
      after(:create) do |subscriber|
        subscriber.unsubscribed_at = Time.current
        subscriber.save
      end
    end
  end
end
