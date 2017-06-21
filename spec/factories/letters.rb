FactoryGirl.define do
  factory :letter do
    name { Faker::Name.name }
    streak_key { HCFaker::Random.alphanumeric_string(len: 91) }
    letter_type { %w(9001 9002 9003).sample }
    what_to_send { %w(9001 9002 9006 9005 9003 9007 9004).sample }
    address { HCFaker::Address.full_address }
    final_weight { rand(30..80) }
    notes { [nil, Faker::Hacker.say_something_smart].sample }
  end
end
