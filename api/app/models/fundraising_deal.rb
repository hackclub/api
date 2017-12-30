# frozen_string_literal: true
# FundraisingDeal represents a donor, potential or current, that is currently
# part of our fundraising progress.
#
# This model exists for syncing our fundraising Streak pipeline to our database
# so we can run SQL reports on it.
class FundraisingDeal < ApplicationRecord
  include Streakable

  streak_pipeline_key Rails.application.secrets.streak_fundraising_pipeline_key
  streak_default_field_mappings key: :streak_key,
                                stage: :stage_key,
                                name: :name,
                                notes: :notes

  streak_field_mappings(
    actual_amount: '1001',
    target_amount: '1004',
    source: '1005',
    probability_of_close: '1006'
  )

  validates :name, presence: true
end
