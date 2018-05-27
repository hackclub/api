# frozen_string_literal: true

class AddNewLeaderReferenceToLeaders < ActiveRecord::Migration[5.2]
  def change
    add_reference :leaders, :new_leader, foreign_key: true
  end
end
