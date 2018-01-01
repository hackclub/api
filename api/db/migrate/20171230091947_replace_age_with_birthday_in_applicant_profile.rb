# frozen_string_literal: true

class ReplaceAgeWithBirthdayInApplicantProfile < ActiveRecord::Migration[5.0]
  def up
    add_column :applicant_profiles, :leader_birthday, :date
    remove_column :applicant_profiles, :leader_age
  end
end
