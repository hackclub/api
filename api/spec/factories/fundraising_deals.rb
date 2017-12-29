# frozen_string_literal: true
FactoryBot.define do
  factory :fundraising_deal do
    name { [Faker::Name.name, Faker::Company.name].sample }
    streak_key { HCFaker::Random.alphanumeric_string(len: 91) }
    stage_key { %w(5001 5002 5003 5006 5007).sample }
    actual_amount { [rand(1000..1_000_000), nil].sample }
    target_amount { [rand(1000..1_000_000), nil].sample }
    probability_of_close { [rand(1..100), nil].sample }
    source { [%w(Referral Self-Sourced Inbound).sample, nil].sample }
    notes { [Faker::Lorem.sentence, nil].sample }
  end
end
