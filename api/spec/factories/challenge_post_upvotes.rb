# frozen_string_literal: true

FactoryBot.define do
  factory :challenge_post_upvote do
    association challenge_post
    association user
  end
end
