# frozen_string_literal: true
class AddReaonOfDeathToClub < ActiveRecord::Migration[5.0]
  def change
    add_column :clubs, :reason_of_death, :text
  end
end
