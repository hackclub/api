# frozen_string_literal: true

class CreateLoginCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :login_codes do |t|
      t.references :user, foreign_key: true
      t.text :code
      t.inet :ip_address
      t.text :user_agent
      t.datetime :used_at

      t.timestamps
    end
  end
end
