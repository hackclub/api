# frozen_string_literal: true

# Disabling this Rubocop check because it was implemented after this migration
# was written.
#
# rubocop:disable Rails/ReversibleMigration
class RemoveOldApplicantHabtmRelationships < ActiveRecord::Migration[5.0]
  def change
    # figure it's not worth preserving the data from this table since it was
    # only used in development
    drop_table :applicants_new_club_applications
  end
end
# rubocop:enable Rails/ReversibleMigration
