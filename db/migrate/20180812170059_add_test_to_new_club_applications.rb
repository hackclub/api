# frozen_string_literal: true

class AddTestToNewClubApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :new_club_applications, :test, :boolean
  end
end
