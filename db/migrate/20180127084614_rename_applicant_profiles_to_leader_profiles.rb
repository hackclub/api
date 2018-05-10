# frozen_string_literal: true

class RenameApplicantProfilesToLeaderProfiles < ActiveRecord::Migration[5.1]
  def change
    rename_table :applicant_profiles, :leader_profiles
  end
end
