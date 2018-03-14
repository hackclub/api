# frozen_string_literal: true

class EventPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
