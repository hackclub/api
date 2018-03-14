# frozen_string_literal: true

FactoryBot.define do
  factory :event_banner do
    after(:build) do |banner|
      File.open(test_files.join('event_banner.jpg')) do |f|
        banner.file.attach(
          io: f, filename: File.basename(f.path), content_type: 'image/jpeg'
        )
      end
    end
  end
end
