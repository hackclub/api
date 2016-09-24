FactoryGirl.define do
  factory :club do
    name HCFaker::HighSchool.name
    address HCFaker::Address.full_address
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude
    source ["Word of mouth", "Searching online", "Press"].sample
    notes Faker::Lorem.sentence
  end
end
