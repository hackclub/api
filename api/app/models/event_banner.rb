# frozen_string_literal: true

class EventBanner < Attachment
  validate :ensure_file_is_image

  def ensure_file_is_image
    errors.add(:file, 'must be an image') unless file.image?
  end

  def file_to_render
    file.variant(
      # optimize
      strip: true,
      interlace: 'Plane',
      gaussian_blur: 0.05,
      quality: '85%',
      define: 'jpeg:dct-method=float',
      sampling_factor: '4:2:0',
      # resize
      resize: '300x'
    )
  end
end
