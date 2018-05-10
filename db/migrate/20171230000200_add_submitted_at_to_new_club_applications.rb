# frozen_string_literal: true

class AddSubmittedAtToNewClubApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :new_club_applications, :submitted_at, :datetime
  end
end
