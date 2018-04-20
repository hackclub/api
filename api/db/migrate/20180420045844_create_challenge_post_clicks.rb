# frozen_string_literal: true

class CreateChallengePostClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_post_clicks do |t|
      t.references :challenge_post, foreign_key: true
      t.references :user, foreign_key: true
      t.inet :ip_address
      t.text :referer
      t.text :user_agent

      t.timestamps
    end
  end
end
