# frozen_string_literal: true

class LeaderProfile < ApplicationRecord
  include Geocodeable

  # preserve information from record deletions
  acts_as_paranoid

  belongs_to :user
  belongs_to :new_club_application

  validates :user, :new_club_application, presence: true
  validates :leader_email, email: true, if: -> { leader_email.present? }

  enum leader_year_in_school: %i[
    freshman
    sophomore
    junior
    senior
    other_year
  ]

  enum leader_gender: %i[
    male
    female
    genderqueer
    agender
    other_gender
  ]

  enum leader_ethnicity: %i[
    hispanic_or_latino
    white
    black
    native_american_or_indian
    asian_or_pacific_islander
    other_ethnicity
  ]

  geocode_attrs address: :leader_address,
                latitude: :leader_latitude,
                longitude: :leader_longitude,
                res_address: :leader_parsed_address,
                city: :leader_parsed_city,
                state: :leader_parsed_state,
                state_code: :leader_parsed_state_code,
                postal_code: :leader_parsed_postal_code,
                country: :leader_parsed_country,
                country_code: :leader_parsed_country_code

  REQUIRED_FOR_COMPLETION = %i[
    leader_name leader_email leader_birthday leader_year_in_school
    leader_gender leader_ethnicity leader_phone_number leader_address
    skills_system_hacked skills_impressive_achievement skills_is_technical
  ].freeze

  validate :make_immutable, if: -> { submitted_at.present? }

  before_create :prefill_leader_email, if: -> { leader_email.blank? }
  before_save :update_completion_status

  def prefill_leader_email
    self.leader_email = user.email
  end

  # automatically set or unset completed_at if all REQUIRED_FOR_COMPLETION
  # fields are set (or not set)
  def update_completion_status
    completed = true

    REQUIRED_FOR_COMPLETION.each do |r|
      completed = false if self[r].nil? || self[r] == ''
    end

    if completed
      self.completed_at = Time.current unless completed_at
    else
      self.completed_at = nil
    end
  end

  def make_immutable
    errors.add(:base, 'cannot edit leader profile after submit') if changed?
  end

  def submitted_at
    self&.new_club_application&.submitted_at
  end
end
