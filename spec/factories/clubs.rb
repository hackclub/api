FactoryGirl.define do
  factory :club do
    name { HCFaker::HighSchool.name }

    # Random 91 character alphanumeric string
    streak_key do
      range = [*'0'..'9',*'A'..'Z',*'a'..'z']
      Array.new(91){ range.sample }.join
    end

    address { HCFaker::Address.full_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    source { ["Word of Mouth", "Searching online", "Press"].sample }
    notes { Faker::Lorem.sentence }

    factory :club_with_leaders do
      transient do
        leader_count 2
      end

      after(:create) do |club, evaluator|
        evaluator.leader_count.times { create(:leader).clubs << club }
      end
    end
  end
end
