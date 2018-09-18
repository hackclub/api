# frozen_string_literal: true

class LeaderProfilePolicy < ApplicationPolicy
  def show?
    owns_profile? || user.admin?
  end

  def update?
    owns_profile?
  end

  private

  def owns_profile?
    record.user == user
  end
end
