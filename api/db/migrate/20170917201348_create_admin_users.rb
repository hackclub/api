# frozen_string_literal: true
class CreateAdminUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      t.text :team
      t.text :access_token

      t.timestamps
    end
  end
end
