# frozen_string_literal: true

class CheckIn < ApplicationRecord
  belongs_to :club
  belongs_to :leader

  validates :club, :leader, :meeting_date, :attendance, presence: true
end
