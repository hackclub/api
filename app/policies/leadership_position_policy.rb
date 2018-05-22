# frozen_string_literal: true

class LeadershipPositionPolicy < ApplicationPolicy
  def update?
    record.new_club.new_leaders.include?(user.new_leader) || user.admin?
  end

  def destroy?
    record.new_leader.user == user || user.admin?
  end
end
