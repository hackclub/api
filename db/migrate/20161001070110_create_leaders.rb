# frozen_string_literal: true

class CreateLeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :leaders do |t|
      t.text :name
      t.text :gender
      t.text :year
      t.text :email
      t.text :slack_username
      t.text :github_username
      t.text :twitter_username
      t.text :phone_number
      t.text :address
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
