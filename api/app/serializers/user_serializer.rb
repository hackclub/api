# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email

  attribute :created_at, if: :logged_in?
  attribute :updated_at, if: :logged_in?
  attribute :admin_at, if: :logged_in?

  def logged_in?
    current_user.present?
  end
end
