# frozen_string_literal: true

class AddStartAndEndMonthsToNewClubs < ActiveRecord::Migration[5.2]
  def change
    add_column :new_clubs, :high_school_start_month, :integer
    add_column :new_clubs, :high_school_end_month, :integer
  end
end
