# frozen_string_literal: true
class CreateAthulClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :athul_clubs do |t|
      t.references :club, foreign_key: true
      t.references :leader, foreign_key: true
      t.references :letter, foreign_key: true

      t.timestamps
    end
  end
end
