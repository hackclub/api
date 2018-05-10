# frozen_string_literal: true

class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.text :name
      t.text :description
      t.datetime :start
      t.datetime :end
      t.references :creator, references: :users

      t.timestamps
    end

    add_foreign_key :challenges, :users, column: :creator_id
  end
end
