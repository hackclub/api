# frozen_string_literal: true

class AddSendCheckInsToNewClubs < ActiveRecord::Migration[5.2]
  def change
    add_column :new_clubs, :send_check_ins, :boolean
  end
end
