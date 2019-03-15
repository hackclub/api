# frozen_string_literal: true

class SendApplicationToAirtableJob < ApplicationJob
  queue_as :default

  def perform(new_club_application)
    club_record = Airtable::Record.new("High School Name": new_club_application.high_school_name)

    table('Clubs').create club_record

    poc = new_club_application.leader_profiles.find_by(user_id: new_club_application.point_of_contact_id)
    leader_record = Airtable::Record.new(
      "Full Name": poc.leader_name,
      "Email": poc.leader_email,
      "Clubs": [club_record.id]
    )

    table('Leaders').create leader_record

    note_record = Airtable::Record.new(
      "Type": ['Application submitted', 'Note'],
      "Club": [club_record.id],
      "Date": Date.today.to_s,
      "Notes": 'Application submitted (and added to Airtable by API)'
    )

    table('History').create note_record
  end

  private

  def client
    @client ||= Airtable::Client.new(Rails.application.secrets.airtable_key)
  end

  def table(table_name)
    client.table Rails.application.secrets.airtable_base, table_name
  end
end
