# frozen_string_literal: true
class AddPointOfContactToClub < ActiveRecord::Migration[5.0]
  def change
    add_reference :clubs, :point_of_contact, index: true
    add_foreign_key :clubs, :leaders, column: :point_of_contact_id
  end
end
