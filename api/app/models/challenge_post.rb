# frozen_string_literal: true

class ChallengePost < ApplicationRecord
  include Recoverable
  include Rails.application.routes.url_helpers

  belongs_to :creator, class_name: 'User'
  belongs_to :challenge

  has_many :upvotes, class_name: 'ChallengePostUpvote', dependent: :destroy
  has_many :clicks, class_name: 'ChallengePostClick', dependent: :destroy

  validates :name, :url, :creator, :challenge, presence: true

  validate :challenge_is_open

  def challenge_is_open
    return unless challenge

    if Time.current < challenge.start
      errors.add(:base, 'challenge has not started yet')
    elsif Time.current > challenge.end
      errors.add(:base, 'challenge has already ended')
    end
  end

  def url_redirect
    return nil unless persisted?

    url_for [:v1_post_redirect, post_id: id]
  end

  def click_count
    clicks.count
  end
end
