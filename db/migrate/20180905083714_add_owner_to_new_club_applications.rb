# frozen_string_literal: true

class AddOwnerToNewClubApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :new_club_applications,
                  :owner,
                  foreign_key: { to_table: :users }
  end
end
