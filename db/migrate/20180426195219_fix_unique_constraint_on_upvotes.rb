# frozen_string_literal: true

class FixUniqueConstraintOnUpvotes < ActiveRecord::Migration[5.2]
  def change
    remove_index :challenge_post_upvotes,
                 column: %i[challenge_post_id user_id],
                 unique: true

    add_index :challenge_post_upvotes, %i[challenge_post_id user_id deleted_at],
              unique: true,
              name: 'unique_by_post_and_user'
  end
end
