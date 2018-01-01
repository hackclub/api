# frozen_string_literal: true

class AddCreatedAtAndUpdatedAtToApplicantProfiles < ActiveRecord::Migration[5.0]
  class Applicant < ApplicationRecord
    has_many :applicant_profiles
  end

  class ApplicantProfile < ApplicationRecord
    belongs_to :applicant
    belongs_to :new_club_application
  end

  class NewClubApplication < ApplicationRecord
    has_many :applicant_profiles
  end

  def up
    add_column :applicant_profiles, :created_at, :datetime
    add_column :applicant_profiles, :updated_at, :datetime

    # set created_at and updated_at to the most recent creation of applicant or
    # new club application
    ApplicantProfile.find_each do |profile|
      most_recent = [
        profile.applicant.created_at,
        profile.new_club_application.created_at
      ].max

      profile.update_attributes(created_at: most_recent,
                                updated_at: most_recent)
    end

    change_column :applicant_profiles, :created_at, :datetime, null: false
    change_column :applicant_profiles, :updated_at, :datetime, null: false
  end

  def down
    remove_column :applicant_profiles, :created_at
    remove_column :applicant_profiles, :updated_at
  end
end
