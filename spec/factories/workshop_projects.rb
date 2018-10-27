# frozen_string_literal: true

FactoryBot.define do
  factory :workshop_project do # barebones requirements
    workshop_slug { %w[personal_website that_was_easy dodge].sample }
    code_url { Faker::Internet.url('github.com') }
    live_url { Faker::Internet.url }
    screenshot { build(:workshop_project_screenshot) }

    factory :workshop_project_with_user do
      user { build(:user) }
    end
  end
end
