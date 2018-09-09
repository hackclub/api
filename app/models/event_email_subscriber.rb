# frozen_string_literal: true

class EventEmailSubscriber < ApplicationRecord
  include Geocodeable

  scope :unconfirmed, -> { where(confirmed_at: nil) }
  scope :subscribed, (lambda do
    where.not(confirmed_at: nil)
         .where(unsubscribed_at: nil)
  end)
  scope :unsubscribed, -> { where.not(unsubscribed_at: nil) }

  before_create :generate_unsubscribe_token
  before_create :generate_confirmation_token
  before_create :generate_link_tracking_token

  after_commit :trigger_rebuild

  validates :email, :location, presence: true
  validates :email,
            :unsubscribe_token,
            :confirmation_token,
            :link_tracking_token,
            uniqueness: true

  geocode_attrs address: :location,
                latitude: :latitude,
                longitude: :longitude,
                res_address: :parsed_address,
                city: :parsed_city,
                state: :parsed_state,
                state_code: :parsed_state_code,
                postal_code: :parsed_postal_code,
                country: :parsed_country,
                country_code: :parsed_country_code

  def self.stats
    filtered = subscribed

    {
      cities: filtered.distinct.count(:parsed_city),
      countries: filtered.distinct.count(:parsed_country)
    }
  end

  def generate_unsubscribe_token
    self.unsubscribe_token = SecureRandom.hex
  end

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex
  end

  def generate_link_tracking_token
    self.link_tracking_token = SecureRandom.hex
  end

  private

  def trigger_rebuild
    RebuildHackathonsSiteJob.perform_later
  end
end
