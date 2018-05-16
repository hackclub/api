# frozen_string_literal: true

class AddUpvoteCountCacheToChallengePosts < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_posts, :upvote_count, :integer
  end
end
