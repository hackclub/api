# frozen_string_literal: true

class NewLeader < ApplicationRecord
  has_many :leadership_positions
  has_many :new_clubs, through: :leadership_positions

  enum gender: %i[
    male
    female
    genderqueer
    agender
    other_gender
  ]

  enum ethnicity: %i[
    hispanic_or_latino
    white
    black
    native_american_or_indian
    asian_or_pacific_islander
    other_ethnicity
  ]

  validates :name, :email, :expected_graduation, :gender, :ethnicity,
            :phone_number, :address, presence: true
end
