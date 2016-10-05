class Leader < ApplicationRecord
  LEADER_PIPELINE = Rails.application.secrets.streak_leader_pipeline_key

  geocoded_by :address # This geocodes :address into :latitude and :longitude
  before_validation :geocode
  before_create :create_leader_box

  has_and_belongs_to_many :clubs

  validates_presence_of :name

  private

  def create_leader_box
    unless self.streak_key
      resp = StreakClient::Box.create_in_pipeline(LEADER_PIPELINE, self.name)
      self.streak_key = resp[:key]
    end
  end
end
