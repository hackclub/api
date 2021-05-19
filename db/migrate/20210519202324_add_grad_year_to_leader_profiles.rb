class AddGradYearToLeaderProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :leader_profiles, :leader_graduation_year, :integer
  end
end
