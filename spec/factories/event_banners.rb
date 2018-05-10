# frozen_string_literal: true

FactoryBot.define do
  factory :event_banner do
    after(:build) do |banner|
      attach_file(banner.file, test_files.join('event_banner.jpg'))
    end
  end
end
