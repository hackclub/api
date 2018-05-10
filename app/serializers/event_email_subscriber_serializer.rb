# frozen_string_literal: true

class EventEmailSubscriberSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :email, :location, :confirmed_at,
             :unsubscribed_at
end
