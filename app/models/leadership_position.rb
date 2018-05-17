# frozen_string_literal: true

class LeadershipPosition < ApplicationRecord
  include Recoverable

  belongs_to :new_club
  belongs_to :new_leader

  validates :new_club, :new_leader, presence: true
end
