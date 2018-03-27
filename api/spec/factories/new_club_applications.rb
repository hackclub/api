# frozen_string_literal: true

FactoryBot.define do
  factory :new_club_application do
    # new club application ready for submission. only includes required fields +
    # relationships.
    factory :completed_new_club_application do
      transient do
        profile_count 3
      end

      # high school
      high_school_name { HCFaker::HighSchool.name }
      high_school_url { Faker::Internet.url }
      high_school_type { :public_school }
      high_school_address { HCFaker::Address.full_address }

      # leaders
      leaders_team_origin_story { Faker::Lorem.paragraph }

      # progress
      progress_general { Faker::Lorem.paragraph }
      progress_student_interest { Faker::Lorem.paragraph }
      progress_meeting_yet { Faker::Lorem.paragraph }

      # idea
      idea_why { Faker::Lorem.paragraph }
      idea_other_coding_clubs { Faker::Lorem.paragraph }
      idea_other_general_clubs { Faker::Lorem.paragraph }

      # formation
      formation_registered { Faker::Lorem.sentence }
      formation_misc { Faker::Lorem.sentence }

      # other
      other_surprising_or_amusing_discovery { Faker::Lorem.paragraph }

      # curious
      curious_what_convinced { Faker::Lorem.sentence }
      curious_how_did_hear { Faker::Lorem.sentence }

      # relationships
      after(:create) do |application, evaluator|
        # will also create leader profiles
        create_list(:completed_leader_profile, evaluator.profile_count,
                    new_club_application: application)

        application.point_of_contact = application.users.first
        application.save
      end
    end

    factory :submitted_new_club_application,
            parent: :completed_new_club_application do

      after(:create) do |application|
        application.submitted_at = Time.current
        application.save
      end
    end

    factory :interviewed_new_club_application,
            parent: :submitted_new_club_application do

      after(:create) do |application|
        application.interviewed_at = Time.current
        application.interview_duration = 1.hour
        application.interview_notes = Faker::Lorem.paragraph
        application.save
      end
    end
  end
end
