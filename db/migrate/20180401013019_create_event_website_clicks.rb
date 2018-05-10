# frozen_string_literal: true

class CreateEventWebsiteClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :event_website_clicks do |t|
      t.references :event, foreign_key: true
      t.references :event_email_subscriber, foreign_key: true
      t.inet :ip_address
      t.text :referer
      t.text :user_agent

      t.timestamps
    end
  end
end
