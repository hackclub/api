# frozen_string_literal: true

FactoryBot.define do
  # only includes required fields
  factory :new_leader do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    gender { %i[male female].sample }
    ethnicity { :hispanic_or_latino }
    phone_number { '333-333-3333' }
    address { HCFaker::Address.full_address }
  end
end
