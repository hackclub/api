# frozen_string_literal: true

class NewLeaderSerializer < ActiveModel::Serializer
  attribute :id
  attribute :created_at, if: :authorized?
  attribute :updated_at, if: :authorized?
  attribute :name
  attribute :email, if: :authorized?
  attribute :birthday, if: :authorized?
  attribute :expected_graduation, if: :authorized?
  attribute :gender, if: :authorized?
  attribute :ethnicity, if: :authorized?
  attribute :phone_number, if: :authorized?
  attribute :address, if: :authorized?
  attribute :latitude, if: :authorized?
  attribute :longitude, if: :authorized?
  attribute :parsed_address, if: :authorized?
  attribute :parsed_city, if: :authorized?
  attribute :parsed_state, if: :authorized?
  attribute :parsed_state_code, if: :authorized?
  attribute :parsed_postal_code, if: :authorized?
  attribute :parsed_country, if: :authorized?
  attribute :parsed_country_code, if: :authorized?
  attribute :personal_website, if: :authorized?
  attribute :github_url, if: :authorized?
  attribute :linkedin_url, if: :authorized?
  attribute :facebook_url, if: :authorized?
  attribute :twitter_url, if: :authorized?

  def authorized?
    current_user&.admin? || object&.user == current_user
  end
end
