class Leader < ApplicationRecord
  geocoded_by :address # This geocodes :address into :latitude and :longitude
  before_validation :geocode

  has_and_belongs_to_many :clubs

  validates_presence_of :name
end
