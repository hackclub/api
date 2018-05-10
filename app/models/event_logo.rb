# frozen_string_literal: true

class EventLogo < Attachment
  validate :ensure_file_is_image

  def ensure_file_is_image
    errors.add(:file, 'must be an image') unless file.image?
  end

  def file_to_render
    file.variant(resize: 'x150', trim: true)
  end
end
