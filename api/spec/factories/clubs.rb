# frozen_string_literal: true
FactoryBot.define do
  factory :club do
    name { HCFaker::HighSchool.name }
    streak_key { HCFaker::Streak.key }
    stage_key { HCFaker::Streak.stage_key }
    address { HCFaker::Address.full_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    source { ['Word of Mouth', 'Searching online', 'Press'].sample }
    notes { Faker::Lorem.sentence }

    factory :club_with_leaders do
      transient do
        leader_count 2
      end

      after(:create) do |club, evaluator|
        evaluator.leader_count.times { create(:leader).clubs << club }
      end
    end

    factory :alive_club do
      stage_key { HCFaker::Streak.stage_key_alive }
    end

    factory :dead_club do
      stage_key { HCFaker::Streak.stage_key_dead }
    end
  end
end
