# frozen_string_literal: true
FactoryBot.define do
  factory :new_club_application do
    # new club application ready for submission. only includes required fields +
    # relationships.
    factory :completed_new_club_application do
      transient do
        applicant_count 3
      end

      # high school
      high_school_name { HCFaker::HighSchool.name }
      high_school_url { Faker::Internet.url }
      high_school_type { :public_school }
      high_school_address { HCFaker::Address.full_address }

      # leaders
      leaders_video_url { Faker::Internet.url }
      leaders_interesting_project { Faker::Lorem.paragraph }
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
        # will also create applicants
        create_list(:completed_applicant_profile, evaluator.applicant_count,
                    new_club_application: application)

        application.point_of_contact = application.applicants.first
      end
    end
  end
end
