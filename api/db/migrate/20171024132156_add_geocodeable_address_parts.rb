# frozen_string_literal: true

class AddGeocodeableAddressParts < ActiveRecord::Migration[5.0]
  def change
    change_table :leaders do |t|
      t.text :parsed_address
      t.text :parsed_city
      t.text :parsed_state
      t.text :parsed_state_code
      t.text :parsed_postal_code
      t.text :parsed_country
      t.text :parsed_country_code
    end

    change_table :clubs do |t|
      t.text :parsed_address
      t.text :parsed_city
      t.text :parsed_state
      t.text :parsed_state_code
      t.text :parsed_postal_code
      t.text :parsed_country
      t.text :parsed_country_code
    end
  end
end
