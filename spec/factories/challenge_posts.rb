# frozen_string_literal: true

FactoryBot.define do
  # only required fields
  factory :challenge_post do
    name { 'My 90s Website' }
    url { 'https://example.com' }

    association :creator, factory: :user
    association :challenge

    factory :challenge_post_with_upvotes do
      transient do
        upvote_count { 3 }
      end

      after(:create) do |post, evaluator|
        create_list(
          :challenge_post_upvote,
          evaluator.upvote_count,
          challenge_post: post
        )
      end
    end
  end
end
