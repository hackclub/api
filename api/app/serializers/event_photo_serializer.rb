# frozen_string_literal: true

class EventPhotoSerializer < AttachmentSerializer
  attribute(:preview_path) { object.file_path(object.preview) }
end
