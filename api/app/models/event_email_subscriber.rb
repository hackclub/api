# frozen_string_literal: true

class EventEmailSubscriber < ApplicationRecord
  include Geocodeable

  before_create :generate_unsubscribe_token

  validates :email, :location, presence: true
  validates :email, :unsubscribe_token, uniqueness: true

  geocode_attrs address: :location,
                latitude: :latitude,
                longitude: :longitude,
                res_address: :parsed_address,
                city: :parsed_city,
                state: :parsed_state,
                state_code: :parsed_state_code,
                postal_code: :parsed_postal_code,
                country: :parsed_country,
                country_code: :parsed_country_code

  def generate_unsubscribe_token
    self.unsubscribe_token = SecureRandom.hex
  end
end
