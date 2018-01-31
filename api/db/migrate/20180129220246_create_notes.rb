# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.references :noteable, polymorphic: true, index: true
      t.references :user, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
