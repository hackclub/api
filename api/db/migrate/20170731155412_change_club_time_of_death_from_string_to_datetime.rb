class ChangeClubTimeOfDeathFromStringToDatetime < ActiveRecord::Migration[5.0]
  def change
    reversible do |change|
      change.up do
        change_column :clubs, :time_of_death, 'TIMESTAMP USING'\
                                              'to_timestamp(cast('\
                                              'time_of_death AS bigint' \
                                              ') / 1000)'
      end

      change.down do
        change_column :clubs, :time_of_death, "TEXT USING date_part('epoch', " \
                                              'time_of_death)::bigint * 1000'
      end
    end
  end
end
