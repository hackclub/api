# frozen_string_literal: true

class AddPublicToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :public, :boolean
  end
end
