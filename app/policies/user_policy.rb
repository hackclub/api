# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def update?
    record == user
  end
end
