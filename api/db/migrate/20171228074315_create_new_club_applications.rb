class CreateNewClubApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :new_club_applications do |t|
      # school
      t.text :high_school_name
      t.text :high_school_url
      t.integer :high_school_type
      t.text :high_school_address
      t.decimal :high_school_latitude
      t.decimal :high_school_longitude
      t.text :high_school_parsed_address
      t.text :high_school_parsed_city
      t.text :high_school_parsed_state
      t.text :high_school_parsed_state_code
      t.text :high_school_parsed_postal_code
      t.text :high_school_parsed_country
      t.text :high_school_parsed_country_code

      # leaders
      t.text :leaders_video_url
      t.text :leaders_interesting_project
      t.text :leaders_team_origin_story

      # progress
      t.text :progress_general
      t.text :progress_student_interest
      t.text :progress_meeting_yet

      # idea
      t.text :idea_why
      t.text :idea_other_coding_clubs
      t.text :idea_other_general_clubs

      # formation
      t.text :formation_registered
      t.text :formation_misc

      # curious
      t.text :curious_what_convinced
      t.text :curious_how_did_hear

      t.timestamps
    end
  end
end
