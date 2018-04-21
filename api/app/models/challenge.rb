# frozen_string_literal: true

class Challenge < ApplicationRecord
  include Recoverable

  has_many :posts, class_name: 'ChallengePost', dependent: :destroy
  belongs_to :creator, class_name: 'User'

  validates :name, :start, :end, :creator, presence: true

  validate :end_is_not_before_start

  def end_is_not_before_start
    return if self.end.nil? || start.nil?

    errors.add(:end, 'cannot be before start') if start > self.end
  end
end
