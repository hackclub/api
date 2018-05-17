# frozen_string_literal: true

class NewClubPolicy < ApplicationPolicy
  def update?
    leader = NewLeader.find_by(user: user)

    user.admin? || record.new_leaders.include?(leader)
  end
end
