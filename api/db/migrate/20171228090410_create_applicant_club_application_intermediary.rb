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
