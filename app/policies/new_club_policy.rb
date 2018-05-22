# frozen_string_literal: true

class NewClubPolicy < ApplicationPolicy
  def show?
    user.admin? || holds_leadership_position?
  end

  def update?
    user.admin? || holds_leadership_position?
  end

  private

  def holds_leadership_position?
    leader = NewLeader.find_by(user: user)
    record.new_leaders.include?(leader)
  end
end
