# frozen_string_literal: true

class WorkshopProjectScreenshot < Attachment
  validate :ensure_file_is_image

  def ensure_file_is_image
    errors.add(:file, 'must be an image') unless file.image?
  end
end
