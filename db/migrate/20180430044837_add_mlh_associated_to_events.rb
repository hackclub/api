# frozen_string_literal: true

class AddMlhAssociatedToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :mlh_associated, :boolean
  end
end
