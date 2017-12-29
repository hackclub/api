# frozen_string_literal: true
class AddNotesToLeaders < ActiveRecord::Migration[5.0]
  def change
    add_column :leaders, :notes, :text
  end
end
