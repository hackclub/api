# frozen_string_literal: true

# Disabling this check because this table was created before we had this check
# running on our codebase and it's too late to go back and update the migration
# now.
#
# rubocop:disable Rails/CreateTableWithTimestamps
class CreateApplicantClubApplicationIntermediary < ActiveRecord::Migration[5.0]
  def change
    create_table :applicants_new_club_applications, id: false do |t|
      t.belongs_to :applicant, index: false
      t.belongs_to :new_club_application, index: false
    end

    add_index :applicants_new_club_applications, :applicant_id,
              name: 'habtm_applicant_id'
    add_index :applicants_new_club_applications, :new_club_application_id,
              name: 'habtm_new_club_application_id'
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
