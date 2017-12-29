# frozen_string_literal: true
class NewClubApplication < ApplicationRecord
  include Geocodeable

  validate :point_of_contact_is_associated

  has_many :applicant_profiles
  has_many :applicants, through: :applicant_profiles
  belongs_to :point_of_contact, class_name: 'Applicant'

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

  # ensure that the point of contact is an associated applicant
  def point_of_contact_is_associated
    return unless point_of_contact
    return if applicants.include? point_of_contact

    errors.add(:point_of_contact, 'must be an associated applicant')
  end
end
