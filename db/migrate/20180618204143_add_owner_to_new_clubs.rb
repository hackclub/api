# frozen_string_literal: true

class AddOwnerToNewClubs < ActiveRecord::Migration[5.2]
  def change
    add_reference :new_clubs, :owner, foreign_key: { to_table: :users }
  end
end
