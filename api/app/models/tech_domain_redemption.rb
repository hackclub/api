# frozen_string_literal: true
class TechDomainRedemption < ApplicationRecord
  validates :name, :email, :requested_domain, presence: true
  validates :email, email: true

  before_create :submit_request

  def submit_request
    DotTechClient.request_domain(name, email, requested_domain)
  end
end
