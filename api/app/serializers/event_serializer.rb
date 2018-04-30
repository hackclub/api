# frozen_string_literal: true

class EventSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :start,
             :end,
             :name,
             :public,
             :website,
             :website_redirect,
             :hack_club_associated,
             :collegiate,
             :address,
             :latitude,
             :longitude,
             :parsed_address,
             :parsed_city,
             :parsed_state,
             :parsed_state_code,
             :parsed_postal_code,
             :parsed_country,
             :parsed_country_code

  has_one :logo
  has_one :banner

  attribute :hack_club_associated_notes, if: :admin?
  attribute :total_attendance, if: :admin?
  attribute :first_time_hackathon_estimate, if: :admin?

  def admin?
    if current_user
      current_user.admin?
    else
      false
    end
  end
end
