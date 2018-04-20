# frozen_string_literal: true

class ChallengePostClick < ApplicationRecord
  belongs_to :challenge_post
  belongs_to :user

  validates :challenge_post, :ip_address, presence: true
end
