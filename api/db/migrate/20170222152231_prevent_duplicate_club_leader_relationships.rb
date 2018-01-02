# frozen_string_literal: true

class PreventDuplicateClubLeaderRelationships < ActiveRecord::Migration[5.0]
  def up
    # Add an id column so we have a unique way to refer to each record
    execute 'ALTER TABLE clubs_leaders ADD COLUMN id bigserial PRIMARY KEY'

    # Remove duplicate entries (see
    # https://wiki.postgresql.org/wiki/Deleting_duplicates for source)
    execute <<~SQL
      DELETE FROM clubs_leaders
      WHERE id IN (SELECT id
                    FROM (SELECT id,
                            ROW_NUMBER() OVER (PARTITION BY club_id, leader_id ORDER BY id) AS rnum
                          FROM clubs_leaders) t
                    WHERE t.rnum > 1);
SQL

    # Remove the id column because it's no longer needed
    execute 'ALTER TABLE clubs_leaders DROP COLUMN id'

    add_index :clubs_leaders, %i[club_id leader_id],
              unique: true, name: 'index_clubs_leaders_uniqueness'
  end

  def down
    remove_index :clubs_leaders, name: 'index_clubs_leaders_uniqueness'
  end
end
