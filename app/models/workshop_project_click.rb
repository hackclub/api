# frozen_string_literal: true

class WorkshopProjectClick < ApplicationRecord
  enum type_of: %i[live code]

  belongs_to :workshop_project
  belongs_to :user

  validates :type_of, presence: true
end
