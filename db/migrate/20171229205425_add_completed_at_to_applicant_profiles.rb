# frozen_string_literal: true

class AddCompletedAtToApplicantProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :applicant_profiles, :completed_at, :datetime
  end
end
