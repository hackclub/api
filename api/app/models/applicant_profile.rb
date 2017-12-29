# frozen_string_literal: true
class ApplicantProfile < ApplicationRecord
  include Geocodeable

  belongs_to :applicant
  belongs_to :new_club_application

  validates :applicant, :new_club_application, presence: true

  geocode_attrs address: :leader_address,
                latitude: :leader_latitude,
                longitude: :leader_longitude,
                res_address: :leader_parsed_address,
                city: :leader_parsed_city,
                state: :leader_parsed_state,
                state_code: :leader_parsed_state_code,
                postal_code: :leader_parsed_postal_code,
                country: :leader_parsed_country,
                country_code: :leader_parsed_country_code
end
