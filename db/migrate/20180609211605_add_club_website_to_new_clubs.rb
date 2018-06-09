# frozen_string_literal: true

class AddClubWebsiteToNewClubs < ActiveRecord::Migration[5.2]
  def change
    add_column :new_clubs, :club_website, :text
  end
end
