# frozen_string_literal: true

class AddUniqueEmailConstraintToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, column: :email
    add_index :users, :email, unique: true
  end
end
