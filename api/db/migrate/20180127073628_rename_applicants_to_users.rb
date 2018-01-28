# frozen_string_literal: true

class RenameApplicantsToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_table :applicants, :users
    rename_column :applicant_profiles, :applicant_id, :user_id
  end
end
