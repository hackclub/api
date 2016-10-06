class Leader < ApplicationRecord
  STREAK_PIPELINE = Rails.application.secrets.streak_leader_pipeline_key
  STREAK_FIELD_MAPPINGS = {
    email: "1003",
    gender: {
      key: "1001",
      type: "DROPDOWN",
      options: {
        "Male" => "9001",
        "Female" => "9002",
        "Other" => "9003"
      }
    },
    year: {
      key: "1002",
      type: "DROPDOWN",
      options: {
        "2016" => "9010",
        "2017" => "9004",
        "2018" => "9003",
        "2019" => "9002",
        "2020" => "9001",
        "2021" => "9006",
        "2022" => "9009",
        "Graduated" => "9005",
        "Teacher" => "9008",
        "Unknown" => "9007"
      }
    },
    phone_number: "1010",
    slack_username: "1006",
    github_username: "1009",
    twitter_username: "1008",
    address: "1011",
    latitude: "1018",
    longitude: "1019"
  }

  geocoded_by :address # This geocodes :address into :latitude and :longitude
  before_validation :geocode
  before_create :create_leader_box

  has_and_belongs_to_many :clubs

  validates_presence_of :name

  private

  def create_leader_box
    unless self.streak_key
      resp = StreakClient::Box.create_in_pipeline(STREAK_PIPELINE, self.name)
      self.streak_key = resp[:key]

      StreakClient::Box.update(
        self.streak_key,
        notes: self.notes,
        linkedBoxKeys: self.clubs.map(&:streak_key)
      )

      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:email],
        self.email
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:gender][:key],
        STREAK_FIELD_MAPPINGS[:gender][:options][self.gender]
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:year][:key],
        STREAK_FIELD_MAPPINGS[:year][:options][self.year]
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:phone_number],
        self.phone_number
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:slack_username],
        self.slack_username
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:github_username],
        self.github_username
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:twitter_username],
        self.twitter_username
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:address],
        self.address
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:latitude],
        self.latitude
      )
      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:longitude],
        self.longitude
      )
    end
  end
end
