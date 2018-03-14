# frozen_string_literal: true

class Event < ApplicationRecord
  include Geocodeable

  validates :start, :end, :name, :address, presence: true

  has_one :logo, as: :attachable, class_name: 'EventLogo'
  has_one :banner, as: :attachable, class_name: 'EventBanner'

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
