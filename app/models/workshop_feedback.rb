# frozen_string_literal: true

# Used for anonymous feedback submissions on pages like
# https://hackclub.com/workshops/personal_website.
#
# It's a pretty flexible model - feedback is a JSON object that accepts
# anything. We do track IP address to prevent abuse.
#
# workshop_slug is the workshop's path in the URL. For Personal Website, it'd be
# personal_website since it's located at
# https://hackclub.com/workshops/personal_website.
class WorkshopFeedback < ApplicationRecord
  validates :workshop_slug, :feedback, :ip_address, presence: true

  validate :feedback_is_hash

  def feedback_is_hash
    errors.add(:feedback, 'must be an object') if feedback.class != Hash
  end
end
