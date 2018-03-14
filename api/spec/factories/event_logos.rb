# frozen_string_literal: true

FactoryBot.define do
  factory :event_logo do
    after(:build) do |logo|
      File.open(test_files.join('event_logo.png')) do |f|
        logo.file.attach(
          io: f, filename: File.basename(f.path), content_type: 'image/png'
        )
      end
    end
  end
end
