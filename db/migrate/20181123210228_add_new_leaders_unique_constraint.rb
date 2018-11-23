# frozen_string_literal: true

class AddNewLeadersUniqueConstraint < ActiveRecord::Migration[5.2]
  def change
    add_index :new_leaders, :email, unique: true
  end
end
