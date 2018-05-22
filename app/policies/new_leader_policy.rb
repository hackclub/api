# frozen_string_literal: true

class NewLeaderPolicy < ApplicationPolicy
  def update?
    user.admin? || record.user == user
  end
end
