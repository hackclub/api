# frozen_string_literal: true

class SlackAnalyticLog < ApplicationRecord
  validates :data, presence: true
end
