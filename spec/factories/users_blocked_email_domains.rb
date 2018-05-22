# frozen_string_literal: true

FactoryBot.define do
  factory :users_blocked_email_domain, class: 'Users::BlockedEmailDomain' do
    association :creator, factory: :user
    domain { Faker::Internet.domain_name }
  end
end
