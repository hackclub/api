# frozen_string_literal: true

class ChallengePostClick < ApplicationRecord
  include Recoverable

  belongs_to :challenge_post, counter_cache: :click_count
  belongs_to :user

  validates :challenge_post, :ip_address, presence: true
end
