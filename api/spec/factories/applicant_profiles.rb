# frozen_string_literal: true
FactoryBot.define do
  factory :applicant_profile do
    association :applicant
    association :new_club_application

    # applicant profile ready for submission. only includes required fields +
    # relationships.
    factory :completed_applicant_profile do
      association :new_club_application,
        factory: :completed_new_club_application

      # leader fields
      leader_name { Faker::Name.name }
      leader_email { Faker::Internet.email }
      leader_age { [14..18].sample }
      leader_year_in_school { :freshman }
      leader_gender { :female }
      leader_ethnicity { :hispanic_or_latino }
      leader_phone_number { '333-333-3333' }
      leader_address { HCFaker::Address.full_address }

      # skillz
      skills_system_hacked { Faker::Lorem.sentence }
      skills_impressive_achievement { Faker::Lorem.sentence }
      skills_is_technical { true }
    end
  end
end
