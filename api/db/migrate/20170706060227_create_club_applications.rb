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
      t.text :referer
      t.string :phone_number
      t.time :start_date

      t.text :year
      t.text :application_quality
      t.text :rejection_reason
      t.text :source

      t.string :streak_key
      t.string :stage_key
      t.string :notes

      t.timestamps
    end
  end
end
