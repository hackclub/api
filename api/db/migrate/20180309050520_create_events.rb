class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.date :start
      t.date :end
      t.text :name
      t.text :website
      t.text :website_archived
      t.integer :total_attendance
      t.integer :first_time_hackathon_estimate
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

      t.timestamps
    end
  end
end
