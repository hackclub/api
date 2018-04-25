# frozen_string_literal: true

class ChallengePostCommentSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :body

  belongs_to :user
  has_many :children

  # for serializing creator
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email
  end
end
