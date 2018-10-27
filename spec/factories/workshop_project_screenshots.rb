# frozen_string_literal: true

FactoryBot.define do
  factory :workshop_project_screenshot do
    after(:build) do |logo|
      attach_file(logo.file, test_files.join('workshop_project_screenshot.png'))
    end
  end
end
