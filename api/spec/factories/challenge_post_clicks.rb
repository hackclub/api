# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :challenge_post_click do
    association :challenge_post
    ip_address { Faker::Internet.ip_v4_address }
  end
end
