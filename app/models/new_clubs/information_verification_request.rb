# frozen_string_literal: true

module NewClubs
  class InformationVerificationRequest < ApplicationRecord
    belongs_to :new_club
    belongs_to :verifier, class_name: 'User'

    validates :new_club, presence: true

    validates :verifier, presence: { if: -> { verified_at.present? } }
    validates :verified_at, presence: { if: -> { verifier.present? } }

    validate :verified_at_cannot_be_changed_after_set

    def verified_at_cannot_be_changed_after_set
      return unless verified_at_was.present? && verified_at_changed?

      errors.add(:verified_at, 'cannot be changed after already set')
    end
  end
end
