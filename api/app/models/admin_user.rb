class AdminUser < ApplicationRecord
  validates :team, uniqueness: true
end
