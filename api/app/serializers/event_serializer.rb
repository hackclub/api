# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :start,
             :end,
             :name,
             :website,
             :address,
             :latitude,
             :longitude
end
