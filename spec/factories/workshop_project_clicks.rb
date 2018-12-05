# frozen_string_literal: true

FactoryBot.define do
  factory :workshop_project_click do
    workshop_project :workshop_project
    type_of :type_of
    ip_address { Faker::Internet.ip_v1_address }
  end
end
