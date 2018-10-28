# frozen_string_literal: true

FactoryBot.define do
  factory :event_group do
    name { ['Local Hack Day 2018', 'CodeDay Fall 2018'].sample }
    location { ['North America', 'International'].sample }

    factory :event_group_w_photos do
      association :logo, factory: :event_logo
      association :banner, factory: :event_banner
    end
  end
end
