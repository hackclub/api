# frozen_string_literal: true

class ChallengePostCommentSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :parent_id,
             :body

  belongs_to :user

  # for serializing creator
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email
  end
end
