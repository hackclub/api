# frozen_string_literal: true

class AddOtherSurprisingOrAmusingDiscoveryToNewClubApplications < ActiveRecord::Migration[5.0] # rubocop:disable Metrics/LineLength
  def change
    add_column :new_club_applications, :other_surprising_or_amusing_discovery,
               :text
  end
end
