# frozen_string_literal: true

class AddDeletedAtToChallengePostClick < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_post_clicks, :deleted_at, :datetime
    add_index :challenge_post_clicks, :deleted_at
  end
end
