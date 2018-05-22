# frozen_string_literal: true

class NewClub < ApplicationRecord
  include Geocodeable

  has_many :new_club_applications

  has_many :leadership_positions
  has_many :leadership_position_invites
  has_many :new_leaders, through: :leadership_positions
  has_many :notes, as: :noteable

  validates :high_school_name, :high_school_address, presence: true

  enum high_school_type: %i[
    public_school
    private_school
    charter_school
    other
  ]

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

  def from_application(app)
    self.high_school_name = app.high_school_name
    self.high_school_url = app.high_school_url
    self.high_school_type = app.high_school_type
    self.high_school_address = app.high_school_address
    self.high_school_latitude = app.high_school_latitude
    self.high_school_longitude = app.high_school_longitude
    self.high_school_parsed_address = app.high_school_parsed_address
    self.high_school_parsed_city = app.high_school_parsed_city
    self.high_school_parsed_state = app.high_school_parsed_state
    self.high_school_parsed_state_code = app.high_school_parsed_state_code
    self.high_school_parsed_postal_code = app.high_school_parsed_postal_code
    self.high_school_parsed_country = app.high_school_parsed_country
    self.high_school_parsed_country_code = app.high_school_parsed_country_code

    app.leader_profiles.each do |profile|
      new_leaders << NewLeader.new.from_leader_profile(profile)
    end

    self
  end
end
