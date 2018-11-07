# frozen_string_literal: true

module Tmp
  # SyncLhdEvents syncs events from Local Hack Day's API to our backend. The
  # current iteration of the script is built for the Dec 1, 2018 event
  # currently being planned.
  #
  # This script uses the hack_club_associated_notes field to store MLH's
  # interal ID for events to dedup them. If that field contains the word "Local
  # Hack Day" and ends with an ID matching one of MLH's IDs, it will be updated
  # instead of a new event being created.
  class SyncLhdEvents < ApplicationJob
    REPEAT_INTERVAL = 1.hour

    API_KEY = Rails.application.secrets.mlh_lhd_api_key

    GROUP_ID = 1
    LOGO_ID = 3488
    BANNER_ID = 3490

    def perform(repeat: false)
      resp = RestClient.get(
        "https://localhackday.mlh.io/api/v1/events.json?api_key=#{API_KEY}"
      )
      json = JSON.parse(resp.body, symbolize_names: true)

      events = json[:data]

      events.each do |event|
        ievent = Event.where(
          'hack_club_associated_notes LIKE ?',
          "%Local Hack Day%#{event[:id]}"
        ).first
        ievent = set_event_fields(event, ievent)

        ievent.save!
      end

      return unless repeat

      SyncLhdEvents.set(wait: REPEAT_INTERVAL).perform_later(repeat: true)
    end

    private

    def set_event_fields(json, event = nil)
      event ||= Event.new

      event.public = true
      event.start = '2018-12-01'
      event.end = '2018-12-01'
      event.group_id = GROUP_ID if GROUP_ID

      if LOGO_ID
        event.logo = EventLogo.new(
          file: EventLogo.find(LOGO_ID).file.blob
        )
      end
      if BANNER_ID
        event.banner = EventBanner.new(
          file: EventBanner.find(BANNER_ID).file.blob
        )
      end

      event.name = "LHD #{json[:organization_name]}"
      event.website = json[:links][:self]
      event.address = %(
#{json[:venue_address_1]}
#{json[:venue_address_2]}
#{json[:venue_city]}, #{json[:venue_state]} #{json[:venue_zipcode]}
#{json[:venue_country]}
      ).strip

      # this metadata allows us to find + update existing LHD events
      event.hack_club_associated_notes =
        'NOTE: This field is being used to dedup LHD events in our sync '\
        "script. Local Hack Day ##{json[:id]}"

      event
    end
  end
end
