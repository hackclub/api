# frozen_string_literal: true

class AddEventSubscriberLinkTracking < ActiveRecord::Migration[5.2]
  def change
    add_column :event_email_subscribers, :link_tracking_token, :text
    add_index :event_email_subscribers, :link_tracking_token, unique: true
  end
end
