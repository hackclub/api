# frozen_string_literal: true
FactoryBot.define do
  factory :leader do
    name { Faker::Name.name }
    streak_key { HCFaker::Random.alphanumeric_string(len: 91) }
    gender { %w(Male Female Other).sample }
    year { %w(2016 2017 Graduated Unknown).sample }
    email { Faker::Internet.email }
    slack_username { [Faker::Internet.user_name, nil].sample }
    github_username { [Faker::Internet.user_name, nil].sample }
    twitter_username { [Faker::Internet.user_name, nil].sample }
    phone_number { [Faker::PhoneNumber.phone_number, nil].sample }
    address { [HCFaker::Address.full_address, nil].sample }
    latitude { Faker::Address.latitude if address }
    longitude { Faker::Address.longitude if address }
  end
end
