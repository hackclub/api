# frozen_string_literal: true

class AddUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :text
    add_index :users, :username, unique: true
  end
end
