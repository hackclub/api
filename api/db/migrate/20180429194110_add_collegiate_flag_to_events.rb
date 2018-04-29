# frozen_string_literal: true

class AddCollegiateFlagToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :collegiate, :boolean
  end
end
