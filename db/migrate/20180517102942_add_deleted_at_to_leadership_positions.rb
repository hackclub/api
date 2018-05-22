# frozen_string_literal: true

class AddDeletedAtToLeadershipPositions < ActiveRecord::Migration[5.2]
  def change
    add_column :leadership_positions, :deleted_at, :datetime
    add_index :leadership_positions, :deleted_at
  end
end
