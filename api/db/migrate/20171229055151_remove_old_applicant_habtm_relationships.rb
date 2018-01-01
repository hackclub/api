# frozen_string_literal: true

class RemoveOldApplicantHabtmRelationships < ActiveRecord::Migration[5.0]
  def change
    # figure it's not worth preserving the data from this table since it was
    # only used in development
    drop_table :applicants_new_club_applications
  end
end
