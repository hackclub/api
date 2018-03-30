# frozen_string_literal: true

class CreateEventEmailSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :event_email_subscribers do |t|
      t.text :email
      t.text :location
      t.decimal :latitude
      t.decimal :longitude
      t.text :parsed_address
      t.text :parsed_city
      t.text :parsed_state
      t.text :parsed_state_code
      t.text :parsed_postal_code
      t.text :parsed_country
      t.text :parsed_country_code
      t.datetime :unsubscribed_at
      t.text :unsubscribe_token

      t.timestamps
    end

    add_index :event_email_subscribers, :email, unique: true
    add_index :event_email_subscribers, :unsubscribe_token, unique: true
  end
end
