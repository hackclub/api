# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :username,
            uniqueness: { if: -> { username.present? } },
            format: { with: /\A[a-z0-9]+\z/, unless: -> { username.nil? } }
  validates :login_code, uniqueness: { if: -> { login_code.present? } }
  validates :auth_token, uniqueness: { if: -> { auth_token.present? } }
  validates :email_on_new_challenges,
            :email_on_new_challenge_posts,
            :email_on_new_challenge_post_comments,
            inclusion: { in: [true, false] }

  validate :username_cannot_be_unset

  has_many :leader_profiles
  has_many :new_club_applications, through: :leader_profiles

  belongs_to :new_leader
  has_many :leadership_position_invites

  has_many :owned_club_applications,
           class_name: 'NewClubApplication',
           foreign_key: 'owner_id',
           inverse_of: :owner
  has_many :owned_clubs,
           class_name: 'NewClub',
           foreign_key: 'owner_id',
           inverse_of: :owner
  
  has_many :challenge_posts,
           foreign_key: 'creator_id',
           inverse_of: :creator

  after_initialize :default_values
  before_validation :downcase_email
  before_create :set_username_if_unset
  before_create :shadow_ban_if_email_blocked

  def username_cannot_be_unset
    return unless persisted?
    return unless username_changed?
    return if username.present?

    errors.add(:username, 'cannot unset username')
  end

  def default_values
    return if persisted?

    if email_on_new_challenge_post_comments.nil?
      self.email_on_new_challenge_post_comments = true
    end

    self.email_on_new_challenges ||= false
    self.email_on_new_challenge_posts ||= false
  end

  def downcase_email
    email&.downcase!
  end

  def set_username_if_unset
    return if username.present?

    self.username = email.split('@').first
    username.gsub!(/[^a-z0-9]/, '') # strip special chars

    # we good if username is unique
    return unless User.find_by(username: username)

    # if not unique, make it unique
    count = 2
    count += 1 while User.find_by(username: username + count.to_s)

    # set unique value
    self.username = username + count.to_s
  end

  def shadow_ban_if_email_blocked
    # find domains that match the end of the user's email
    matches = Users::BlockedEmailDomain.where("? LIKE ('%' || domain)", email)
    return if matches.empty?

    shadow_ban!
  end

  def generate_login_code!
    loop do
      self.login_code = SecureRandom.random_number(999_999).to_s
      self.login_code = login_code.ljust(6, '0') # left pad w/ zeros

      self.login_code_generation = Time.current

      # repeat until code is unique
      break unless User.find_by(login_code: login_code)
    end
  end

  # "123456" -> "123-456"
  def pretty_login_code
    login_code&.scan(/.../)&.join('-')
  end

  def generate_auth_token!
    loop do
      self.auth_token = SecureRandom.hex(32)
      self.auth_token_generation = Time.current

      # repeat until token is unique
      break unless User.find_by(auth_token: auth_token)
    end
  end

  def make_admin!
    self.admin_at = Time.current
  end

  def remove_admin!
    self.admin_at = nil
  end

  def admin?
    admin_at.present?
  end

  def shadow_ban!
    self.shadow_banned_at = Time.current
  end

  def shadow_banned?
    shadow_banned_at.present?
  end
end
