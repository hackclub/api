class Club < ApplicationRecord
  STREAK_PIPELINE = Rails.application.secrets.streak_club_pipeline_key
  STREAK_FIELD_MAPPINGS = {
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
  }

  geocoded_by :address # This geocodes :address into :latitude and :longitude
  before_validation :geocode

  before_create :create_streak_box
  before_update :update_streak_box
  before_destroy :destroy_streak_box

  has_and_belongs_to_many :leaders

  validates_presence_of :name, :address, :latitude, :longitude

  def destroy_without_streak!
    self.class.skip_callback(:destroy, :before, :destroy_streak_box)
    self.destroy!
    self.class.set_callback(:destroy, :before, :destroy_streak_box)
  end

  private

  def create_streak_box
    unless self.streak_key
      resp = StreakClient::Box.create_in_pipeline(STREAK_PIPELINE, self.name)
      self.streak_key = resp[:key]

      StreakClient::Box.update(
        self.streak_key,
        notes: self.notes,
        linkedBoxKeys: self.leaders.map(&:streak_key)
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

      StreakClient::Box.edit_field(
        self.streak_key,
        STREAK_FIELD_MAPPINGS[:source][:key],
        STREAK_FIELD_MAPPINGS[:source][:options][self.source]
      )
    end
  end

  def update_streak_box
    StreakClient::Box.update(
      self.streak_key,
      notes: self.notes,
      linkedBoxKeys: self.leaders.map(&:streak_key)
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

    StreakClient::Box.edit_field(
      self.streak_key,
      STREAK_FIELD_MAPPINGS[:source][:key],
      STREAK_FIELD_MAPPINGS[:source][:options][self.source]
    )
  end

  def destroy_streak_box
    StreakClient::Box.delete(self.streak_key)
  end
end
