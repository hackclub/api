FactoryBot.define do
  factory :applicant do
    email { Faker::Internet.email }
  end
end
