# frozen_string_literal: true

class AddEventGroupToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :group, foreign_key: { to_table: :event_groups }
  end
end
