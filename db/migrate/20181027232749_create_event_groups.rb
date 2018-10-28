# frozen_string_literal: true

class CreateEventGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :event_groups do |t|
      t.text :name
      t.text :location

      t.timestamps
    end
  end
end
