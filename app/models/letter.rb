class Letter < ApplicationRecord
  include Streakable

  streak_pipeline_key Rails.application.secrets.streak_letter_pipeline_key
  streak_default_field_mappings key: :streak_key, name: :name, notes: :notes
  streak_field_mappings(
    letter_type: {
      key: '1002',
      type: 'DROPDOWN',
      options: {
        'Donor' => '9001',
        'Club Leader' => '9002',
        'Other' => '9003'
      }
    },
    address: '1004',
    what_to_send: {
      key: '1005',
      type: 'DROPDOWN',
      options: {
        'Stickers, 1oz' => '9001',
        'Stickers, 3oz' => '9002',
        'Welcome letter and stickers, 1oz' => '9006',
        'Welcome letter and stickers, 3oz' => '9005',
        'Hack Night stickers' => '9003',
        'Prophet Orpheus Sticker' => '9007',
        'Other' => '9004'
      }
    },
    final_weight: '1008'
  )

  validates :name, :address, presence: true
  validates :streak_key, uniqueness: true
end
