# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def update?
    user.admin?
  end
end
