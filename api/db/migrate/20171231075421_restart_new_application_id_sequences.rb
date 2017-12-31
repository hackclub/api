# frozen_string_literal: true
# For all the new tables created for the new application process, start their ID
# counts at the current application count.
class RestartNewApplicationIdSequences < ActiveRecord::Migration[5.0]
  # current # of club applications as of creation of this migration
  COUNT = 3388

  def change
    execute <<-SQL
      ALTER SEQUENCE applicants_id_seq RESTART WITH #{COUNT};
      ALTER SEQUENCE applicant_profiles_id_seq RESTART WITH #{COUNT};
      ALTER SEQUENCE new_club_applications_id_seq RESTART WITH #{COUNT};
    SQL
  end
end
