# frozen_string_literal: true

class ChallengePost < ApplicationRecord
  include Recoverable
  include Rails.application.routes.url_helpers

  belongs_to :creator, class_name: 'User'
  belongs_to :challenge

  has_many :upvotes, class_name: 'ChallengePostUpvote', dependent: :destroy
  has_many :clicks, class_name: 'ChallengePostClick', dependent: :destroy

  validates :name, :url, :creator, :challenge, presence: true

  def url_redirect
    return nil unless persisted?

    url_for [:v1_post_redirect, post_id: id]
  end

  def click_count
    clicks.count
  end
end
