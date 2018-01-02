# frozen_string_literal: true

class CreateDonors < ActiveRecord::Migration[5.0]
  def change
    create_table :donors do |t|
      t.string :email
      t.string :stripe_id

      t.timestamps
    end
  end
end
