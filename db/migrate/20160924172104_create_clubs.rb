# frozen_string_literal: true

class CreateClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs do |t|
      t.text :name
      t.text :address
      t.decimal :latitude
      t.decimal :longitude
      t.text :source
      t.text :notes

      t.timestamps
    end
  end
end
