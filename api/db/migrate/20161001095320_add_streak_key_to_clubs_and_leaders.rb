# frozen_string_literal: true

class AddStreakKeyToClubsAndLeaders < ActiveRecord::Migration[5.0]
  def change
    add_column :clubs, :streak_key, :text
    add_column :leaders, :streak_key, :text
  end
end
