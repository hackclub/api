# frozen_string_literal: true

class CreateLeadershipPositions < ActiveRecord::Migration[5.1]
  def change
    create_table :leadership_positions do |t|
      t.references :new_club, foreign_key: true
      t.references :new_leader, foreign_key: true

      t.timestamps
    end
  end
end
