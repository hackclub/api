# frozen_string_literal: true

class CreateChallengePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_posts do |t|
      t.text :name
      t.text :url
      t.text :description
      t.references :creator, references: :users
      t.references :challenge, foreign_key: true

      t.timestamps
    end

    add_foreign_key :challenge_posts, :users, column: :creator_id
  end
end
