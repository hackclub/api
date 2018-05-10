# frozen_string_literal: true

class AddEmailOnNewChallengesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_on_new_challenges, :bool
  end
end
