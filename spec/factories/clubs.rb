FactoryGirl.define do
  factory :club do
    name HCFaker::HighSchool.name
    address HCFaker::Address.full_address
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude
    source ["Word of mouth", "Searching online", "Press"].sample
    notes Faker::Lorem.sentence

    factory :club_with_leaders do
      transient do
        leaders_count 2
      end

      after(:create) do |club, evaluator|
        evaluator.leaders_count.times { create(:leader).clubs << club }
      end
    end
  end
end
