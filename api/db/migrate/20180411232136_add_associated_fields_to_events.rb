# frozen_string_literal: true

class AddAssociatedFieldsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :hack_club_associated, :boolean
    add_column :events, :hack_club_associated_notes, :text
  end
end
