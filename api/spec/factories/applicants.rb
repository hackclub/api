# frozen_string_literal: true
FactoryBot.define do
  factory :applicant do
    email { Faker::Internet.email }

    factory :applicant_authed do
      after(:build) do |applicant|
        applicant.generate_login_code!

        # make it look like the login code was generated a minute ago
        applicant.login_code_generation -= 1.minute

        applicant.generate_auth_token!
      end
    end
  end
end
