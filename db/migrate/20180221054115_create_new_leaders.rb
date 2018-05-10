# frozen_string_literal: true

class CreateNewLeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :new_leaders do |t|
      t.text :name
      t.text :email
      t.date :birthday
      t.date :expected_graduation
      t.integer :gender
      t.integer :ethnicity
      t.text :phone_number
      t.text :address
      t.decimal :latitude
      t.decimal :longitude
      t.text :parsed_address
      t.text :parsed_city
      t.text :parsed_state
      t.text :parsed_state_code
      t.text :parsed_postal_code
      t.text :parsed_country
      t.text :parsed_country_code
      t.text :personal_website
      t.text :github_url
      t.text :linkedin_url
      t.text :facebook_url
      t.text :twitter_url

      t.timestamps
    end
  end
end
