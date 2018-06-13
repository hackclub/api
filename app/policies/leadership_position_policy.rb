# frozen_string_literal: true

class LeadershipPositionPolicy < ApplicationPolicy
  # TODO: Only the point of contact should be able to do these.
  def update?
    club_includes_current_leader? || user.admin?
  end

  def destroy?
    club_includes_current_leader? || user.admin?
  end

  private

  def club_includes_current_leader?
    record.new_club.new_leaders.include?(user.new_leader)
  end
end
