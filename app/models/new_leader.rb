# frozen_string_literal: true

class NewLeader < ApplicationRecord
  include Geocodeable

  has_many :leadership_positions
  has_many :new_clubs, through: :leadership_positions
  has_one :user

  has_one :leader # store reference to associated legacy leader if available

  enum gender: %i[
    male
    female
    genderqueer
    agender
    other_gender
  ]

  enum ethnicity: %i[
    hispanic_or_latino
    white
    black
    native_american_or_indian
    asian_or_pacific_islander
    other_ethnicity
  ]

  validates :name, :email, :gender, :ethnicity, :phone_number, :address,
            presence: true

  validates :personal_website, :github_url, :linkedin_url, :facebook_url,
            :twitter_url, url: true

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

  def from_leader_profile(profile)
    self.name = profile.leader_name
    self.email = profile.leader_email
    self.birthday = profile.leader_birthday
    self.expected_graduation = calculate_expected_graduation(
      profile.leader_year_in_school
    )
    self.gender = profile.leader_gender
    self.ethnicity = profile.leader_ethnicity
    self.phone_number = profile.leader_phone_number

    self.address = profile.leader_address
    self.latitude = profile.leader_latitude
    self.longitude = profile.leader_longitude
    self.parsed_address = profile.leader_parsed_address
    self.parsed_city = profile.leader_parsed_city
    self.parsed_state = profile.leader_parsed_state
    self.parsed_state_code = profile.leader_parsed_state_code
    self.parsed_postal_code = profile.leader_parsed_postal_code
    self.parsed_country = profile.leader_parsed_country
    self.parsed_country_code = profile.leader_parsed_country_code

    self.personal_website = profile.presence_personal_website
    self.github_url = profile.presence_github_url
    self.linkedin_url = profile.presence_linkedin_url
    self.facebook_url = profile.presence_facebook_url
    self.twitter_url = profile.presence_twitter_url

    self
  end

  def calculate_expected_graduation(year_in_school)
    graduation_month = 6

    upcoming_graduation = if Time.current.month > graduation_month
                            Time.gm(Time.current.year + 1, graduation_month)
                          else
                            Time.gm(Time.current.year, graduation_month)
                          end

    case year_in_school.intern
    when :senior
      upcoming_graduation
    when :junior
      upcoming_graduation + 1.year
    when :sophomore
      upcoming_graduation + 2.years
    when :freshman
      upcoming_graduation + 3.years
    end
  end
end
