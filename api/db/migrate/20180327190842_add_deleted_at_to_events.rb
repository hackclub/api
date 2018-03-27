# frozen_string_literal: true

class AddDeletedAtToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :deleted_at, :datetime
    add_index :events, :deleted_at
  end
end
