# frozen_string_literal: true

class CreateChallengePostUpvotes < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_post_upvotes do |t|
      t.references :challenge_post, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :challenge_post_upvotes, %i[challenge_post_id user_id],
              unique: true
  end
end
