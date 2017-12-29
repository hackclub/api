# frozen_string_literal: true
class Donor < ApplicationRecord
  validates :email, :stripe_id, presence: true
  validates :email, :stripe_id, uniqueness: true
end
