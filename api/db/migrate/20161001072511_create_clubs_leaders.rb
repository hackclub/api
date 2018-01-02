# frozen_string_literal: true

# Disabling this Rubocop check because it was implemented after this migration
# was written.
#
# rubocop:disable Rails/CreateTableWithTimestamps
class CreateClubsLeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs_leaders, id: false do |t|
      t.belongs_to :club, index: true
      t.belongs_to :leader, index: true
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
