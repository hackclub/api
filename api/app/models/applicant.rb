class Applicant < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates_uniqueness_of :login_code, if: 'login_code.present?'
  validates_uniqueness_of :auth_token, if: 'auth_token.present?'

  def generate_login_code
    loop do
      self.login_code = SecureRandom.random_number(999999).to_s
      self.login_code = self.login_code.ljust(6, '0') # left pad w/ zeros

      self.login_code_generation = Time.now

      # repeat until code is unique
      break unless Applicant.find_by(login_code: self.login_code)
    end
  end

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.hex(32)
      self.auth_token_generation = Time.now

      # repreat until token is unique
      break unless Applicant.find_by(auth_token: self.auth_token)
    end
  end
end
