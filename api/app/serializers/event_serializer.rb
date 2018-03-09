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
             :longitude,
             :parsed_address,
             :parsed_city,
             :parsed_state,
             :parsed_state_code,
             :parsed_postal_code,
             :parsed_country,
             :parsed_country_code
end
