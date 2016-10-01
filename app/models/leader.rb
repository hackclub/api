class Leader < ApplicationRecord
  geocoded_by :address # This geocodes :address into :latitude and :longitude
  before_validation :geocode

  validates_presence_of :name
end
