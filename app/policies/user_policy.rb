# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    record == user || user.admin?
  end

  def update?
    record == user
  end
end
