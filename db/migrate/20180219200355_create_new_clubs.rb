# frozen_string_literal: true

class CreateNewClubs < ActiveRecord::Migration[5.1]
  def change
    create_table :new_clubs do |t|
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

      t.timestamps
    end
  end
end
