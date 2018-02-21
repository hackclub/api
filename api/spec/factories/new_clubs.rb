# frozen_string_literal: true

FactoryBot.define do
  # only includes required fields
  factory :new_club do
    high_school_name { HCFaker::HighSchool.name }
    high_school_address { HCFaker::Address.full_address }
  end
end
