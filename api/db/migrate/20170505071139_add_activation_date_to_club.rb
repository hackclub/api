# frozen_string_literal: true

class AddActivationDateToClub < ActiveRecord::Migration[5.0]
  def change
    add_column :clubs, :activation_date, :text
  end
end
