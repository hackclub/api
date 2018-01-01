# frozen_string_literal: true

class Club < ApplicationRecord
  ACTIVE_STAGE = '5003'
  DORMANT_STAGE = '5014'
  DEAD_STAGE = '5007'

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
    activation_date: '1015',
    reason_of_death: '1018',
    time_of_death: {
      key: '1023',
      type: 'DATE'
    }
  )

  streak_read_only point_of_contact_name: '1012'

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

  has_many :check_ins
  belongs_to :point_of_contact, class_name: 'Leader'
  has_and_belongs_to_many :leaders

  validates :name, :address, :latitude, :longitude, presence: true

  before_destroy do
    # Remove them from any associated AthulClubs
    a = AthulClub.find_by(club_id: id)
    a&.update_attributes!(club_id: nil)
  end

  # This getter returns the point_of_contact_name.
  #
  # Disabling Rubocop's delegate check because converting this to a prefixed
  # delegate breaks Streakable's tests.
  def point_of_contact_name
    point_of_contact&.name
  end

  def dead?
    stage_key == DEAD_STAGE
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

  def make_active
    self.stage_key = ACTIVE_STAGE

    save
  end

  def make_dormant(resurrection_date = nil)
    self.stage_key = DORMANT_STAGE
    self.activation_date = resurrection_date

    save
  end

  def time_of_death=(ts)
    # Streak stores dates as milliseconds since epoch, so we want to handle
    # integers coming from UpdateFromStreakJob

    if ts.is_a? Integer
      super DateTime.strptime(ts.to_s, '%Q')
    else
      super ts
    end
  end
end
