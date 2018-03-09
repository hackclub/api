class Event < ApplicationRecord
  include Geocodeable

  validates_presence_of :start, :end, :name, :address

  geocode_attrs address: :address,
                latitude: :latitude,
                longitude: :longitude,
                res_address: :parsed_address,
                city: :parsed_city,
                state: :parsed_state,
                state_code: :parsed_state_code,
                postal_code: :parsed_postal_code,
                country: :parsed_country,
                country_code: :parsed_country_code
end
