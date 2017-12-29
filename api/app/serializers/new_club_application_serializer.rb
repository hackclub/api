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
    :leaders_video_url,
    :leaders_interesting_project,
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
    :point_of_contact_id

  has_many :applicant_profiles

  class ApplicantProfileSerializer < ActiveModel::Serializer
    attributes :id
    has_one :applicant

    class ApplicantSerializer < ActiveModel::Serializer
      attributes :id, :email
    end
  end
end
