# frozen_string_literal: true

# Disabling this Rubocop check because it was implemented after this migration
# was written.
#
# rubocop:disable Rails/CreateTableWithTimestamps
class CreateApplicantProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :applicant_profiles do |t|
      t.belongs_to :applicant
      t.belongs_to :new_club_application

      # leader
      t.text :leader_name
      t.text :leader_email
      t.text :leader_age
      t.integer :leader_year_in_school
      t.integer :leader_gender
      t.integer :leader_ethnicity
      t.text :leader_phone_number
      t.text :leader_address

      # geocoded attrs
      t.decimal :leader_latitude
      t.decimal :leader_longitude
      t.text :leader_parsed_address
      t.text :leader_parsed_city
      t.text :leader_parsed_state
      t.text :leader_parsed_state_code
      t.text :leader_parsed_postal_code
      t.text :leader_parsed_country
      t.text :leader_parsed_country_code

      # presence
      t.text :presence_personal_website
      t.text :presence_github_url
      t.text :presence_linkedin_url
      t.text :presence_facebook_url
      t.text :presence_twitter_url

      # skills
      t.text :skills_system_hacked
      t.text :skills_impressive_achievement
      t.boolean :skills_is_technical
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
