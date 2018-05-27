# frozen_string_literal: true

class AddNewClubReferenceToClubs < ActiveRecord::Migration[5.2]
  def change
    add_reference :clubs, :new_club, foreign_key: true
  end
end
