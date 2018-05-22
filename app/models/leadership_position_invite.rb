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
end
