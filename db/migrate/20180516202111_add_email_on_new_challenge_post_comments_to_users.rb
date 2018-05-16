# frozen_string_literal: true

class AddEmailOnNewChallengePostCommentsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_on_new_challenge_post_comments, :bool
  end
end
