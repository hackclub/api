class AddStreakKeyIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :clubs, :streak_key
    add_index :leaders, :streak_key
    add_index :letters, :streak_key
  end
end
