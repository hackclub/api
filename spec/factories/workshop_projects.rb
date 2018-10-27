# frozen_string_literal: true

FactoryBot.define do
  factory :workshop_project do # barebones requirements
    workshop_slug { %w[personal_website that_was_easy dodge].sample }
    code_url { Faker::Internet.url('github.com') }
    live_url { Faker::Internet.url }
  end
end
