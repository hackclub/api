# frozen_string_literal: true

class AddDeletedAtToChallengePostUpvote < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_post_upvotes, :deleted_at, :datetime
    add_index :challenge_post_upvotes, :deleted_at
  end
end
