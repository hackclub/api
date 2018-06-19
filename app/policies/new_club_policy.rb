# frozen_string_literal: true

class NewClubPolicy < ApplicationPolicy
  def permitted_attributes
    attrs = %i[
      high_school_name
      high_school_type
      high_school_address
      high_school_start_month
      high_school_end_month
      club_website
    ]

    attrs << :owner_id if user.admin?

    attrs
  end

  def show?
    user.admin? || holds_leadership_position?
  end

  def update?
    user.admin? || holds_leadership_position?
  end

  def check_ins_index?
    user.admin? || holds_leadership_position?
  end

  private

  def holds_leadership_position?
    leader = NewLeader.find_by(user: user)
    record.new_leaders.include?(leader)
  end
end
