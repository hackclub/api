# frozen_string_literal: true

class AddChallengeEmailSubscriptionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_on_new_challenge_posts, :boolean
  end
end
