# frozen_string_literal: true

class NewClubApplicationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at,
             :high_school_name,
             :high_school_url,
             :high_school_type,
             :high_school_address,
             :high_school_latitude,
             :high_school_longitude,
             :high_school_parsed_address,
             :high_school_parsed_city,
             :high_school_parsed_state,
             :high_school_parsed_state_code,
             :high_school_parsed_postal_code,
             :high_school_parsed_country,
             :high_school_parsed_country_code,
             :leaders_team_origin_story,
             :progress_general,
             :progress_student_interest,
             :progress_meeting_yet,
             :idea_why,
             :idea_other_coding_clubs,
             :idea_other_general_clubs,
             :formation_registered,
             :formation_misc,
             :other_surprising_or_amusing_discovery,
             :curious_what_convinced,
             :curious_how_did_hear,
             :point_of_contact_id,
             :submitted_at,
             :interviewed_at,
             :interview_duration

  attribute :interview_notes, if: :admin?

  has_many :leader_profiles

  # for admin? method
  delegate :admin?, to: :current_user

  class LeaderProfileSerializer < ActiveModel::Serializer
    attributes :id, :completed_at
    has_one :user

    class UserSerializer < ActiveModel::Serializer
      attributes :id, :email
    end
  end
end
