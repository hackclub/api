class Club < ApplicationRecord
  include Streakable

  streak_pipeline_key Rails.application.secrets.streak_club_pipeline_key
  streak_default_field_mappings key: :streak_key, name: :name, notes: :notes
  streak_field_mappings(
    address: "1006",
    latitude: "1007",
    longitude: "1008",
    source: {
      key: "1004",
      type: "DROPDOWN",
      options: {
        "Word of Mouth" => "9001",
        "Unknown" => "9002",
        "Free Code Camp" => "9003",
        "GitHub" => "9004",
        "Press" => "9005",
        "Searching online" => "9006",
        "Hackathon" => "9007",
        "Website" => "9008",
        "Social media" => "9009",
        "Hack Camp" => "9010"
      }
    }
  )

  geocoded_by :address # This geocodes :address into :latitude and :longitude
  before_validation :geocode, if: -> (club) { club.address.present? and club.address_changed? }

  has_and_belongs_to_many :leaders

  validates_presence_of :name, :address, :latitude, :longitude
end
