# frozen_string_literal: true

class EventPhoto < Attachment
  validate :ensure_file_format

  def ensure_file_format
    content_type = file.content_type

    errors.add(:file, 'must be a jpeg or png image') unless
      content_type.end_with?('jpeg', 'png')
  end

  def preview
    file_to_render.variant(
      # optimize
      strip: true,
      interlace: 'Plane',
      gaussian_blur: 0.05,
      quality: '85%',
      define: 'jpeg:dct-method=float',
      sampling_factor: '4:2:0',
      # resize
      resize: '500x'
    )
  end
end
