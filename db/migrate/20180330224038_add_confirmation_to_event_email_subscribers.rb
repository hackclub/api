# frozen_string_literal: true

class AddConfirmationToEventEmailSubscribers < ActiveRecord::Migration[5.2]
  def change
    add_column :event_email_subscribers, :confirmed_at, :datetime
    add_column :event_email_subscribers, :confirmation_token, :text
    add_index :event_email_subscribers, :confirmation_token, unique: true
  end
end
