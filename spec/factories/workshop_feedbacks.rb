# frozen_string_literal: true

FactoryBot.define do
  factory :workshop_feedback do
    workshop_slug { %w[personal_website that_was_easy].sample }

    feedback do
      obj = {}

      rand(1..5).times do
        obj[Faker::Lorem.sentence] = Faker::Lorem.paragraph
      end

      obj
    end

    ip_address do
      [
        Faker::Internet.ip_v4_address,
        Faker::Internet.ip_v6_address
      ].sample
    end
  end
end
