# frozen_string_literal: true

FactoryBot.define do
  factory :leadership_position_invite do
    association :sender, factory: :user
    association :new_club
    association :user
  end
end
