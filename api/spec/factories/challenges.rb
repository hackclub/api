# frozen_string_literal: true

FactoryBot.define do
  factory :challenge do
    name { Faker::AquaTeenHungerForce.character }
    description { Faker::BackToTheFuture.quote }
    start { rand(1..5).days.ago }
    add_attribute(:end) { rand(6..30).days.from_now }

    association :creator, factory: :user
  end
end
