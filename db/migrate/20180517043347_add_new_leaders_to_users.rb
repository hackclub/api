# frozen_string_literal: true

class AddNewLeadersToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :new_leader, foreign_key: true
  end
end
