# frozen_string_literal: true

class EventWebsiteClick < ApplicationRecord
  belongs_to :event
  belongs_to :email_subscriber,
             class_name: 'EventEmailSubscriber',
             foreign_key: 'event_email_subscriber_id'

  validates :event, :ip_address, presence: true
end
