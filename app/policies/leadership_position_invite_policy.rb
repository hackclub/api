# frozen_string_literal: true

class LeadershipPositionInvitePolicy < ApplicationPolicy
  def create?
    user.admin? || record.new_club.new_leaders.include?(user.new_leader)
  end

  def accept?
    record.user == user
  end

  def reject?
    record.user == user
  end
end
