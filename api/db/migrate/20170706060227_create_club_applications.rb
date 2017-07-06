class CreateClubApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :club_applications do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :github
      t.string :twitter
      t.string :high_school
      t.string :interesting_project
      t.string :systems_hacked
      t.string :steps_taken
      t.integer :year
      t.text :referer
      t.string :phone_number
      t.string :start_date

      t.timestamps
    end
  end
end
