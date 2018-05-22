# frozen_string_literal: true

module Users
  class BlockedEmailDomain < ApplicationRecord
    belongs_to :creator, class_name: 'User'

    validates :creator, :domain, presence: true
    validates :domain, uniqueness: true

    validate :domain_is_a_domain

    def domain_is_a_domain
      return if domain.blank?

      begin
        # force the domain we'll validate to start with http:// to force ruby's
        # uri parses to use its http mode instead of uri::generic
        uri = URI.parse('http://' + domain)

        # does the parsed host = the domain provided
        valid = uri.host == domain
      rescue URI::InvalidURIError
        valid = false
      end

      return if valid == true

      errors.add(:domain, 'must be a domain')
    end
  end
end
