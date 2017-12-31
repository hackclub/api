# frozen_string_literal: true
class AddDeletedAtToApplicantProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :applicant_profiles, :deleted_at, :datetime
    add_index :applicant_profiles, :deleted_at
  end
end
