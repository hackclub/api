# frozen_string_literal: true

class NewClub < ApplicationRecord
  validates :high_school_name, :high_school_address, presence: true

  enum high_school_type: %i[
    public_school
    private_school
    charter_school
    other
  ]
end
