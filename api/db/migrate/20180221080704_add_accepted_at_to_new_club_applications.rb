# frozen_string_literal: true

class AddAcceptedAtToNewClubApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :new_club_applications, :accepted_at, :datetime
  end
end
