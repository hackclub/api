# frozen_string_literal: true
FactoryBot.define do
  factory :applicant do
    email { Faker::Internet.email }
  end
end
