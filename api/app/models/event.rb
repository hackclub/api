# frozen_string_literal: true

class Event < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Geocodeable

  acts_as_paranoid

  validates :start, :end, :name, :website, :address, presence: true
  validates :hack_club_associated, inclusion: { in: [true, false] }

  validate :hack_club_associated_notes_set_if_needed

  # hack_club_associated_notes should be set if hack_club_associated is true
  def hack_club_associated_notes_set_if_needed
    return unless hack_club_associated
    return if hack_club_associated_notes.present?

    errors.add(:hack_club_associated_notes, "can't be blank")
  end

  has_one :logo, as: :attachable, class_name: 'EventLogo'
  has_one :banner, as: :attachable, class_name: 'EventBanner'
  has_many :photos, as: :attachable, class_name: 'EventPhoto'

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

  after_initialize :default_values
  after_create :queue_notification_emails
  after_commit :trigger_rebuild

  def default_values
    return if persisted?

    self.hack_club_associated ||= false
  end

  def queue_notification_emails
    return if start < Time.current

    SendEventNotificationEmailsJob.set(wait: 1.day).perform_later(id)
  end

  def trigger_rebuild
    RebuildHackathonsSiteJob.perform_later
  end

  def website_redirect(event_email_subscriber = nil)
    return nil unless persisted?

    if event_email_subscriber
      url_for [
        :v1_event_redirect,
        event_id: id,
        token: event_email_subscriber.link_tracking_token
      ]
    else
      url_for [:v1_event_redirect, event_id: id]
    end
  end
end
