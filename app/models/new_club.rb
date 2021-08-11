# frozen_string_literal: true

class NewClub < ApplicationRecord
  include Geocodeable

  scope :dead, -> { where.not(died_at: nil) }

  belongs_to :owner, class_name: 'User'

  has_many :new_club_applications

  has_many :leadership_positions
  has_many :leadership_position_invites
  has_many :information_verification_requests,
           class_name: 'NewClubs::InformationVerificationRequest'
  has_many :new_leaders, through: :leadership_positions
  has_many :notes, as: :noteable

  has_one :club # store reference to legacy NewClub if available

  validates :high_school_name, :high_school_address, presence: true
  validates :send_check_ins, inclusion: { in: [true, false] }

  # any num between 0 - 11 or nil
  validates :high_school_start_month, :high_school_end_month,
            inclusion: { in: (0..11).to_a + [nil] }

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

  after_initialize :default_values

  def default_values
    return if persisted?

    self.send_check_ins ||= false
  end

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
