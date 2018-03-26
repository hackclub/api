# frozen_string_literal: true

class ChallengePost < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :challenge

  has_many :upvotes, class_name: 'ChallengePostUpvote'

  validates :name, :url, :creator, :challenge, presence: true
end
