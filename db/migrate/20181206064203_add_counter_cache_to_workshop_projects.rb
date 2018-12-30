# frozen_string_literal: true

class AddCounterCacheToWorkshopProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :workshop_projects, :clicks_count, :integer
  end
end
