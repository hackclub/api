# frozen_string_literal: true

class CreateUsersBlockedEmailDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :users_blocked_email_domains do |t|
      t.text :domain
      t.references :creator, foreign_key: { to_table: :users }
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users_blocked_email_domains, %i[domain deleted_at], unique: true
  end
end
