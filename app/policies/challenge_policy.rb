# frozen_string_literal: true

class ChallengePolicy < ApplicationPolicy
  def create?
    user.admin?
  end
end
