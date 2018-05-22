# frozen_string_literal: true

class LeadershipPositionInvite < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :new_club
  belongs_to :user
  belongs_to :leadership_position

  validates :sender, :new_club, :user, presence: true
  validates :accepted_at, absence: true, if: -> { rejected_at.present? }
  validates :rejected_at, absence: true, if: -> { accepted_at.present? }

  # a user cannot have multiple invites out to join the same club
  validates :user, uniqueness: { scope: %i[new_club rejected_at] }

  validate :sender_is_not_user

  def sender_is_not_user
    return unless sender == user

    errors.add(:user, 'cannot be the same as sender')
  end

  def accept!
    if user.new_leader.blank?
      errors.add(:user, 'must have associated new_leader')

      return false
    end

    self.leadership_position = LeadershipPosition.new(
      new_club: new_club,
      new_leader: user.new_leader
    )
    self.accepted_at = Time.current

    save
  end

  def reject!
    if rejected_at.present?
      errors.add(:base, 'already rejected')
      return
    end

    self.rejected_at = Time.current

    save
  end
end
