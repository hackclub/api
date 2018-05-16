# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email

  attribute :username, if: :logged_in?
  attribute :created_at, if: :logged_in?
  attribute :updated_at, if: :logged_in?
  attribute :admin_at, if: :logged_in?
  attribute :email_on_new_challenges, if: :logged_in?
  attribute :email_on_new_challenge_posts, if: :logged_in?
  attribute :email_on_new_challenge_post_comments, if: :logged_in?

  def logged_in?
    current_user.present?
  end
end
