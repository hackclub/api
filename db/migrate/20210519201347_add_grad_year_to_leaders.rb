class AddGradYearToLeaders < ActiveRecord::Migration[5.2]
  def change
    add_column :leaders, :leader_graduation_year, :integer
  end
end
