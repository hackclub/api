# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    factory :user_authed do
      after(:build) do |user|
        login_code = user.login_codes.new

        # make it look like the login code was generated a minute ago
        login_code.created_at = Time.current - 1.minute

        user.generate_auth_token!
        login_code.used_at = Time.current
      end
    end

    factory :user_shadowbanned_authed do
      after(:build) do |user|
        login_code = user.login_codes.new

        # make it look like the login code was generated a minute ago
        login_code.created_at = Time.current - 1.minute

        user.generate_auth_token!
        login_code.used_at = Time.current

        # shadowban
        user.shadow_ban!
      end
    end

    factory :user_admin_authed do
      after(:build) do |user|
        login_code = user.login_codes.new

        # make it look like the login code was generated a minute ago
        login_code.created_at = Time.current - 1.minute

        user.generate_auth_token!
        login_code.used_at = Time.current

        # make them admin
        user.make_admin!
      end
    end
  end
end
