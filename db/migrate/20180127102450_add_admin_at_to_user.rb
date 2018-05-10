# frozen_string_literal: true

class AddAdminAtToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin_at, :datetime
  end
end
