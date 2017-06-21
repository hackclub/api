class Club < ApplicationRecord
  ACTIVE_STAGE = '5003'.freeze
  DORMANT_STAGE = '5014'.freeze

  include Streakable
  include Geocodeable

  streak_pipeline_key Rails.application.secrets.streak_club_pipeline_key
  streak_default_field_mappings key: :streak_key, name: :name, notes: :notes,
                                stage: :stage_key
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
    },
    point_of_contact_name: '1012',
    activation_date: '1015'
  )

  geocode_attrs address: :address,
                latitude: :latitude,
                longitude: :longitude

  has_many :check_ins
  belongs_to :point_of_contact, class_name: 'Leader'
  has_and_belongs_to_many :leaders

  validates :name, presence: true
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  # This getter returns the point_of_contact_name.
  def point_of_contact_name
    point_of_contact.name if point_of_contact
  end

  def alive?
    active? || dormant?
  end

  def active?
    stage_key == ACTIVE_STAGE
  end

  def dormant?
    stage_key == DORMANT_STAGE
  end

  # This setter prevents the point of contact name from being set from Streak.
  # The point of contact should only be changed in the database, which will
  # update the Streak pipeline.
  def point_of_contact_name=(_)
    nil
  end

  def make_active
    self.stage_key = ACTIVE_STAGE

    save
  end

  def make_dormant(resurrection_date = nil)
    self.stage_key = DORMANT_STAGE
    self.activation_date = resurrection_date

    save
  end
end
