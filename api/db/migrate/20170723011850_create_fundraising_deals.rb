# frozen_string_literal: true

class CreateFundraisingDeals < ActiveRecord::Migration[5.0]
  def change
    create_table :fundraising_deals do |t|
      t.text :name
      t.text :streak_key
      t.text :stage_key
      t.integer :commitment_amount
      t.integer :amount_in_bank
      t.text :source
      t.text :notes

      t.timestamps
    end

    add_index :fundraising_deals, :streak_key
  end
end
