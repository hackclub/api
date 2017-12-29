# frozen_string_literal: true
FactoryBot.define do
  factory :applicant_profile do
    association :applicant
    association :new_club_application

    # TODO: flesh out as needed
  end
end
