# frozen_string_literal: true

# Not preserving data in this migration because it is part of the same PR that
# interview_duration was added in, so there is no data to preserve.
class ChangeInterviewDurationToInteger < ActiveRecord::Migration[5.1]
  def up
    remove_column :new_club_applications, :interview_duration
    add_column :new_club_applications, :interview_duration, :integer
  end

  def down
    remove_column :new_club_applications, :interview_duration
    add_column :new_club_applications, :interview_duration, :interval
  end
end
