# frozen_string_literal: true

module NewClubs
  class InformationVerificationRequestPolicy < ApplicationPolicy
    def verify?
      LeadershipPosition.find_by(
        new_club: record.new_club,
        new_leader: user.new_leader
      ).present?
    end
  end
end
