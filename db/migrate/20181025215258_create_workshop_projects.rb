# frozen_string_literal: true

class CreateWorkshopProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :workshop_projects do |t|
      t.text :workshop_slug
      t.text :code_url
      t.text :live_url
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :workshop_projects, :workshop_slug
  end
end
