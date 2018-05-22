# frozen_string_literal: true

FactoryBot.define do
  factory :leadership_position do
    association :new_club
    association :new_leader
  end
end
