# frozen_string_literal: true

class AddIndexesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email
    add_index :users, :auth_token
  end
end
