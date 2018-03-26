# frozen_string_literal: true

class ChallengePost < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :challenge

  validates :name, :url, :creator, :challenge, presence: true
end
