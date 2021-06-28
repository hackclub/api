# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    record == user || user.admin?
  end

  def update?
    record == user
  end

  def auth_on_behalf?
    user.admin?
  end
end
