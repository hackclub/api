# frozen_string_literal: true

class WorkshopProject < ApplicationRecord
  belongs_to :user
  has_one :screenshot, as: :attachable, class_name: 'WorkshopProjectScreenshot'

  validates :workshop_slug, :code_url, :live_url, :screenshot, presence: true
  validates :code_url, :live_url, url: true
  validates :workshop_slug, format: { with: /\A[^A-Z ]+\z/ }
end
