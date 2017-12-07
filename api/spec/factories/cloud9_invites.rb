FactoryBot.define do
  factory :cloud9_invite do
    team_name { Rails.application.secrets.cloud9_team_name }
    email { Faker::Internet.email }
  end
end
