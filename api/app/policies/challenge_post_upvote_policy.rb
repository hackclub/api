# frozen_string_literal: true

class ChallengePostUpvotePolicy < ApplicationPolicy
  def destroy?
    record.user == user
  end
end
