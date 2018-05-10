# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :challenge_post do
    name 'My 90s Website'
    url 'https://example.com'

    association :creator, factory: :user
    association :challenge
  end
end
