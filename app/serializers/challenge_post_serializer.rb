# frozen_string_literal: true

class ChallengePostSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :name,
             :url,
             :url_redirect,
             :description,
             :click_count,
             :comment_count,
             :rank_score

  has_one :creator
  has_many :upvotes

  # Filter upvotes to include / not include upvotes created by shadowbanned
  # users depending on who's authenticated.
  def upvotes
    if current_user == object.creator # return everything
      object.upvotes
    elsif current_user&.shadow_banned? # return non-shadowbanned + own votes
      object.upvotes.select do |u|
        u.user.shadow_banned? == false || u.user == current_user
      end
    else # return non-shadowbanned
      object.upvotes.select { |u| u.user.shadow_banned? == false }
    end
  end

  # for serializing creator
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :username
  end

  class ChallengePostUpvoteSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :updated_at

    has_one :user
  end
end
