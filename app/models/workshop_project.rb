# frozen_string_literal: true

class WorkshopProject < ApplicationRecord
  belongs_to :user
  has_one :screenshot, as: :attachable, class_name: 'WorkshopProjectScreenshot'
  has_many :workshop_project_clicks

  validates :workshop_slug, :code_url, :live_url, presence: true
  validates :code_url, :live_url, url: true
  validates :workshop_slug, format: { with: /\A[^A-Z ]+\z/ }

  before_create :capture_screenshot_if_missing

  # Captures a screenshot from the live_url, overriding the existing screenshot
  # currently set.
  def capture_screenshot
    screenshot_file = ScreenshotClient.capture(live_url, format: 'JPG')

    screenshot = WorkshopProjectScreenshot.new
    screenshot.file.attach(
      io: screenshot_file,
      filename: 'screenshot.jpg'
    )

    self.screenshot = screenshot
  end

  private

  def capture_screenshot_if_missing
    return if screenshot.present?

    capture_screenshot
  end
end
