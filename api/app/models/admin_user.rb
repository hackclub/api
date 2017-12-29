# frozen_string_literal: true
class AdminUser < ApplicationRecord
  validates :team, uniqueness: true
end
