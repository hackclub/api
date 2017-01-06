class Club < ApplicationRecord
  include Streakable
  include Geocodeable

  streak_pipeline_key Rails.application.secrets.streak_club_pipeline_key
  streak_default_field_mappings key: :streak_key, name: :name, notes: :notes
  streak_field_mappings(
    address: '1006',
    latitude: '1007',
    longitude: '1008',
    source: {
      key: '1004',
      type: 'DROPDOWN',
      options: {
        'Word of Mouth' => '9001',
        'Unknown' => '9002',
        'Free Code Camp' => '9003',
        'GitHub' => '9004',
        'Press' => '9005',
        'Searching online' => '9006',
        'Hackathon' => '9007',
        'Website' => '9008',
        'Social media' => '9009',
        'Hack Camp' => '9010'
      }
    }
  )

  geocode_attrs address: :address,
                latitude: :latitude,
                longitude: :longitude

  has_and_belongs_to_many :leaders
  has_many :check_ins

  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
