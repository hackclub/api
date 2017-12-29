# frozen_string_literal: true
# rubocop:disable Metrics/ClassLength
class Leader < ApplicationRecord
  include Streakable
  include Geocodeable

  DEFAULT_SLACK_TEAM_ID = Rails.application.secrets.default_slack_team_id

  streak_pipeline_key Rails.application.secrets.streak_leader_pipeline_key
  streak_default_field_mappings key: :streak_key, name: :name, notes: :notes,
                                stage: :stage_key
  streak_field_mappings(
    email: '1003',
    gender: {
      key: '1001',
      type: 'DROPDOWN',
      options: {
        'Male' => '9001',
        'Female' => '9002',
        'Other' => '9003'
      }
    },
    year: {
      key: '1002',
      type: 'DROPDOWN',
      options: {
        '2016' => '9010',
        '2017' => '9004',
        '2018' => '9003',
        '2019' => '9002',
        '2020' => '9001',
        '2021' => '9006',
        '2022' => '9009',
        'Graduated' => '9005',
        'Teacher' => '9008',
        'Unknown' => '9007'
      }
    },
    phone_number: '1010',
    slack_username: '1006',
    github_username: '1009',
    twitter_username: '1008',
    address: '1011',
    latitude: '1018',
    longitude: '1019',
    slack_id: '1020'
  )

  geocode_attrs address: :address,
                latitude: :latitude,
                longitude: :longitude,
                res_address: :parsed_address,
                city: :parsed_city,
                state: :parsed_state,
                state_code: :parsed_state_code,
                postal_code: :parsed_postal_code,
                country: :parsed_country,
                country_code: :parsed_country_code

  before_validation :slack_update

  has_many :check_ins
  has_many :net_promoter_score_surveys
  has_and_belongs_to_many :clubs

  before_destroy do
    # Remove the club leader as the point of contact from any clubs they're
    # associated with.
    Club
      .where(point_of_contact_id: id)
      .find_each { |c| c.update(point_of_contact: nil) }

    # Remove them from any associated AthulClubs
    a = AthulClub.find_by(leader_id: id)
    a.update_attributes!(leader_id: nil) unless a.nil?
  end

  validates :name, presence: true

  def slack_update
    return if access_token.nil?

    if slack_id_changed?
      slack_id_sync
    elsif slack_username_changed?
      slack_username_sync
    end
  end

  def timezone
    Timezone.lookup(latitude, longitude)
  rescue Timezone::Error::InvalidZone
    Rails.logger.warn("Unable to find timezone for leader \##{id}")
    nil
  end

  def resolve_email_to_slack_id
    user = SlackClient::Users
           .list(access_token)[:members]
           .find { |u| u[:profile][:email] == email }

    self.slack_id = user[:id] unless user.nil?
  end

  private

  def slack_id_sync
    info = SlackClient::Users.info(slack_id, access_token)[:user]
    self.slack_username = info[:name] unless info.nil?
  end

  def slack_username_sync
    user = user_from_username slack_username
    self.slack_id = user[:id] unless user.nil?
  end

  def user_from_username(username)
    @all_users ||= SlackClient::Users.list(access_token)[:members]

    @all_users.find { |u| u[:name] == username }
  end

  def access_token
    return nil if team.nil?

    team.bot_access_token
  end

  def team(team_id = slack_team_id)
    Hackbot::Team.find_by(team_id: team_id) ||
      Hackbot::Team.find_by(team_id: DEFAULT_SLACK_TEAM_ID)
  end
end
# rubocop:enable Metrics/ClassLength
