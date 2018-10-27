# frozen_string_literal: true

class WorkshopProject < ApplicationRecord
  belongs_to :user

  validates :workshop_slug, :code_url, :live_url, presence: true
  validates :code_url, :live_url, url: true
  validates :workshop_slug, format: { with: /\A[^A-Z ]+\z/ }
end
