# frozen_string_literal: true
class CreateCheckIns < ActiveRecord::Migration[5.0]
  def change
    create_table :check_ins do |t|
      t.belongs_to :club, foreign_key: true
      t.belongs_to :leader, foreign_key: true
      t.date :meeting_date
      t.integer :attendance
      t.text :notes

      t.timestamps
    end
  end
end
