# frozen_string_literal: true

class NewLeaderPolicy < ApplicationPolicy
  def show?
    return true if record.user == user
    return true if user.admin?

    return false if user.new_leader.nil?
    record.new_clubs.each do |club|
      return true if club.new_leaders.include? user.new_leader
    end
  end

  def update?
    user.admin? || record.user == user
  end
end
