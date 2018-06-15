# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :new_clubs_information_verification_request,
          class: 'NewClubs::InformationVerificationRequest' do
    association :new_club
  end
end
