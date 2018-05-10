# frozen_string_literal: true

class ChangeFieldsInFundraisingDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :fundraising_deals, :actual_amount, :text
    add_column :fundraising_deals, :target_amount, :text
    add_column :fundraising_deals, :probability_of_close, :text

    remove_column :fundraising_deals, :amount_in_bank, :integer
    remove_column :fundraising_deals, :commitment_amount, :integer
  end
end
