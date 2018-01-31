# frozen_string_literal: true

class AddDeletedAtToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :deleted_at, :datetime
    add_index :notes, :deleted_at
  end
end
