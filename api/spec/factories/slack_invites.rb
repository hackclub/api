# frozen_string_literal: true

FactoryBot.define do
  factory :slack_invite do
    email { Faker::Internet.email }
  end
end
