# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    association :user, factory: :user_admin_authed
    association :noteable, factory: :new_club_application

    body { Faker::Lorem.sentence }
  end
end
