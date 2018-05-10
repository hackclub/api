# frozen_string_literal: true

class AddNewClubIdToNewClubApplication < ActiveRecord::Migration[5.1]
  def change
    add_reference :new_club_applications, :new_club, foreign_key: true
  end
end
