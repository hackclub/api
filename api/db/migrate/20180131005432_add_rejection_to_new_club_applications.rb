# frozen_string_literal: true

class AddRejectionToNewClubApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :new_club_applications, :rejected_at, :datetime
    add_column :new_club_applications, :rejected_reason, :integer
    add_column :new_club_applications, :rejected_notes, :text
  end
end
