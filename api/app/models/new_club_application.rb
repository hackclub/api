class NewClubApplication < ApplicationRecord
  include Geocodeable

  has_many :applicant_profiles
  has_many :applicants, through: :applicant_profiles

  geocode_attrs address: :high_school_address,
    latitude: :high_school_latitude,
    longitude: :high_school_longitude,
    res_address: :high_school_parsed_address,
    city: :high_school_parsed_city,
    state: :high_school_parsed_state,
    state_code: :high_school_parsed_state_code,
    postal_code: :high_school_parsed_postal_code,
    country: :high_school_parsed_country,
    country_code: :high_school_parsed_country_code
end
