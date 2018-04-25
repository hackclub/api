# frozen_string_literal: true

class CreateChallengePostComments < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_post_comments do |t|
      t.datetime :deleted_at, index: true
      t.references :user, foreign_key: true
      t.references :challenge_post, foreign_key: true
      t.references :parent, foreign_key: { to_table: :challenge_post_comments }
      t.text :body

      t.timestamps
    end
  end
end
