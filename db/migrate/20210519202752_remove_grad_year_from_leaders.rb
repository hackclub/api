class RemoveGradYearFromLeaders < ActiveRecord::Migration[5.2]
  def change
    remove_column :leaders, :leader_graduation_year, :integer
  end
end
