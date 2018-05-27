# frozen_string_literal: true

class AddDiedAtToNewClubs < ActiveRecord::Migration[5.2]
  def change
    add_column :new_clubs, :died_at, :datetime
    add_index :new_clubs, :died_at
  end
end
