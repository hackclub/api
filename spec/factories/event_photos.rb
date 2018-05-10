# frozen_string_literal: true

FactoryBot.define do
  factory :event_photo do
    after(:build) do |photo|
      attach_file(photo.file, test_files.join('event_photo.jpg'))
    end
  end
end
