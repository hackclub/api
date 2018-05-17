# frozen_string_literal: true

class LeadershipPositionPolicy < ApplicationPolicy
  def update?
    record.new_leader.user == user
  end

  def destroy?
    record.new_leader.user == user || user.admin?
  end
end
