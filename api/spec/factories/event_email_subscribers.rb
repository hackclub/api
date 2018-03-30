# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :event_email_subscriber do
    email { Faker::Internet.email }
    location { "#{Faker::Address.city}, #{Faker::Address.state_abbr}" }
  end
end
