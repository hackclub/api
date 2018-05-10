# frozen_string_literal: true

class AddInterviewFieldsToNewClubApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :new_club_applications, :interviewed_at, :datetime
    add_column :new_club_applications, :interview_duration, :interval
    add_column :new_club_applications, :interview_notes, :text
  end
end
