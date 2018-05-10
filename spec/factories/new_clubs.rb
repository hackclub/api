# frozen_string_literal: true

FactoryBot.define do
  # only includes required fields
  factory :new_club do
    high_school_name { HCFaker::HighSchool.name }
    high_school_address { HCFaker::Address.full_address }

    factory :new_club_w_leaders do
      transient do
        leader_count 3
      end

      after(:create) do |club, evaluator|
        evaluator.leader_count.times do
          club.new_leaders << create(:new_leader)
        end
      end
    end
  end
end
