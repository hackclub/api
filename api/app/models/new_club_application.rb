# frozen_string_literal: true

class NewClubApplication < ApplicationRecord
  include Geocodeable

  validate :point_of_contact_is_associated

  has_many :leader_profiles
  has_many :users, through: :leader_profiles
  belongs_to :point_of_contact, class_name: 'User'
  has_many :notes, as: :noteable

  geocode_attrs address: :high_school_address,
                latitude: :high_school_latitude,
                longitude: :high_school_longitude,
                res_address: :high_school_parsed_address,
                city: :high_school_parsed_city,
                state: :high_school_parsed_state,
                state_code: :high_school_parsed_state_code,
                postal_code: :high_school_parsed_postal_code,
                country: :high_school_parsed_country,
                country_code: :high_school_parsed_country_code

  enum high_school_type: %i[
    public_school
    private_school charter_school
  ]

  with_options if: -> { submitted_at.present? } do |application|
    application.validates :high_school_name,
                          :high_school_type,
                          :high_school_address,
                          :leaders_team_origin_story,
                          :progress_general,
                          :progress_student_interest,
                          :progress_meeting_yet,
                          :idea_why,
                          :idea_other_coding_clubs,
                          :idea_other_general_clubs,
                          :formation_registered,
                          :other_surprising_or_amusing_discovery,
                          :point_of_contact,
                          presence: true

    # ensure leader profiles are complete
    application.validate do |app|
      all_complete = true

      app.leader_profiles.each do |profile|
        all_complete = false unless profile.completed_at
      end

      errors.add(:base, 'leader profiles not complete') unless all_complete
    end
  end

  # submitted_at must be set for interviewed_at to be set
  validates :submitted_at, presence: true, if: -> { interviewed_at.present? }
  validates :interviewed_at, :interview_duration, :interview_notes,
            presence: true, if: lambda {
              interviewed_at.present? ||
                interview_duration.present? ||
                interview_notes.present?
            }

  def submit!
    self.submitted_at = Time.current

    if valid?
      if save
        users.each do |applicant|
          ApplicantMailer.application_submission(self, applicant).deliver_later
        end

        ApplicantMailer.application_submission_staff(self).deliver_later

        true
      else
        false
      end
    else
      self.submitted_at = nil
      false
    end
  end

  def submitted?
    submitted_at.present?
  end

  # ensure that the point of contact is an associated applicant
  def point_of_contact_is_associated
    return unless point_of_contact
    return if users.include? point_of_contact

    errors.add(:point_of_contact, 'must be an associated applicant')
  end
end
