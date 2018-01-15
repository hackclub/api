# frozen_string_literal: true

class Applicant < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :login_code, uniqueness: { if: 'login_code.present?' }
  validates :auth_token, uniqueness: { if: 'auth_token.present?' }

  has_many :applicant_profiles
  has_many :new_club_applications, through: :applicant_profiles

  def generate_login_code!
    loop do
      self.login_code = SecureRandom.random_number(999_999).to_s
      self.login_code = login_code.ljust(6, '0') # left pad w/ zeros

      self.login_code_generation = Time.current

      # repeat until code is unique
      break unless Applicant.find_by(login_code: login_code)
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
      break unless Applicant.find_by(auth_token: auth_token)
    end
  end
end
