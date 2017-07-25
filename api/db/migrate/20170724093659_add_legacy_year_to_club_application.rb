class AddLegacyYearToClubApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :club_applications, :legacy_year, :string
  end
end
