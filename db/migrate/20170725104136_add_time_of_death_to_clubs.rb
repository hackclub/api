# frozen_string_literal: true

class AddTimeOfDeathToClubs < ActiveRecord::Migration[5.0]
  def change
    add_column :clubs, :time_of_death, :text
  end
end
