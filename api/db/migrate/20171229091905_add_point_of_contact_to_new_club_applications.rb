class AddPointOfContactToNewClubApplications < ActiveRecord::Migration[5.0]
  def change
    add_reference :new_club_applications, :point_of_contact,
      references: :applicants, index: true
    add_foreign_key :new_club_applications, :applicants,
      column: :point_of_contact_id
  end
end
