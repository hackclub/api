# frozen_string_literal: true

class ChallengePostUpvote < ApplicationRecord
  include Recoverable

  belongs_to :challenge_post
  belongs_to :user

  validates :challenge_post, :user, presence: true
  validates :challenge_post, uniqueness: { scope: :user }
end
