# frozen_string_literal: true

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at
  attribute(:type) { object.type.underscore }
  attribute(:file_path) { object.file_path }
end
