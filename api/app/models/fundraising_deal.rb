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
    commitment_amount: '1001',
    amount_in_bank: '1003',
    source: '1005'
  )

  validates :name, presence: true
end
