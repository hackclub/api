# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    factory :user_authed do
      after(:build) do |user|
        user.generate_login_code!

        # make it look like the login code was generated a minute ago
        user.login_code_generation -= 1.minute

        user.generate_auth_token!
      end
    end
  end
end
