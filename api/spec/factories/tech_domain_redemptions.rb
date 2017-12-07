FactoryBot.define do
  factory :tech_domain_redemption do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    requested_domain { "#{Faker::Internet.domain_word}.tech" }
  end
end
