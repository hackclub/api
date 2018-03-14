# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :event do
    start { 3.days.from_now }
    add_attribute(:end) { 4.days.from_now }
    name { "#{Faker::Hacker.verb.capitalize}Hacks" }
    address { HCFaker::Address.full_address }

    factory :event_w_photos do
      association :logo, factory: :event_logo
      association :banner, factory: :event_banner
    end
  end
end
