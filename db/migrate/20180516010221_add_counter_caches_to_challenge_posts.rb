# frozen_string_literal: true

class AddCounterCachesToChallengePosts < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_posts, :comment_count, :integer
    add_column :challenge_posts, :click_count, :integer
  end
end
