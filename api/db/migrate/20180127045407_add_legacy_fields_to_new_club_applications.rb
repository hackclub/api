# frozen_string_literal: true

class AddLegacyFieldsToNewClubApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :new_club_applications, :legacy_fields, :json
  end
end
