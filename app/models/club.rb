class Club < ApplicationRecord
  geocoded_by :address # This geocodes :address into :latitude and :longitude
  before_validation :geocode

  validates_presence_of :name, :address, :latitude, :longitude
end
