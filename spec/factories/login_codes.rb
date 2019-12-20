# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :login_code do
    association :user
  end
end
