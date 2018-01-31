# frozen_string_literal: true

class NotePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.admin?
  end

  def update?
    user.admin? && record.user == user
  end

  def destroy?
    user.admin? && record.user == user
  end
end
