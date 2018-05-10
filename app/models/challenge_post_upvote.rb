# frozen_string_literal: true

class ChallengePostUpvote < ApplicationRecord
  include Recoverable

  belongs_to :challenge_post
  belongs_to :user

  validates :challenge_post, :user, presence: true
  validates :challenge_post, uniqueness: { scope: :user }

  validate :challenge_currently_open

  def challenge_currently_open
    return unless challenge_post

    if Time.current < challenge_post.challenge.start
      errors.add(:base, 'challenge has not started yet')
    elsif Time.current > challenge_post.challenge.end
      errors.add(:base, 'challenge has already ended')
    end
  end
end
