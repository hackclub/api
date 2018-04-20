# frozen_string_literal: true

class ChallengePostSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :name,
             :url,
             :url_redirect,
             :description,
             :click_count

  has_one :creator
  has_many :upvotes

  # for serializing creator
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email
  end

  class ChallengePostUpvoteSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :updated_at

    has_one :user
  end
end
