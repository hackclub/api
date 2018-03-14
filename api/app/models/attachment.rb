# frozen_string_literal: true

class Attachment < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :attachable, polymorphic: true

  has_one_attached :file

  validate :file_is_attached

  def file_is_attached
    errors.add(:file, 'must be attached') unless file.attached?
  end

  # override this in subclasses to customize display of file
  def file_to_render
    file
  end

  def file_path
    polymorphic_url(file_to_render, only_path: true)
  end
end
