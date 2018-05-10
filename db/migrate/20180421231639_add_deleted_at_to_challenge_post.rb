# frozen_string_literal: true

class AddDeletedAtToChallengePost < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_posts, :deleted_at, :datetime
    add_index :challenge_posts, :deleted_at
  end
end
