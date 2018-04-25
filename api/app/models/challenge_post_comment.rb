# frozen_string_literal: true

class ChallengePostComment < ApplicationRecord
  include Recoverable

  belongs_to :user
  belongs_to :challenge_post
  belongs_to :parent, class_name: 'ChallengePostComment'

  validates :user, :challenge_post, :body, presence: true
end
