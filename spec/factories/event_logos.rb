# frozen_string_literal: true

FactoryBot.define do
  factory :event_logo do
    after(:build) do |logo|
      attach_file(logo.file, test_files.join('event_logo.png'))
    end
  end
end
