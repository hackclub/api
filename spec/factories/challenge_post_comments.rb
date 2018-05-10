# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :challenge_post_comment do
    association :user
    association :challenge_post
    body { Faker::Lorem.sentence }
  end
end
