class AthulClub < ApplicationRecord
  INDIAN_CLUB_STAGE = '5020'
  INDIAN_LEADER_STAGE = '5008'

  belongs_to :club, dependent: :destroy
  belongs_to :leader, dependent: :destroy
  belongs_to :letter, dependent: :destroy

  accepts_nested_attributes_for :club, :leader

  validates :club, :leader, presence: true
  validates :club, uniqueness: true

  before_create :init

  def init
    club.stage_key = INDIAN_CLUB_STAGE
    leader.stage_key = INDIAN_LEADER_STAGE

    club.leaders << leader
    club.point_of_contact = leader

    letter = Letter.new(
      name: leader.name,
      # This is the type for club leaders
      letter_type: '9002',
      # This is the type for welcome letter + 3oz of stickers
      what_to_send: '9005',
      address: leader.address
    )

    unless club.save && leader.save
      errors.add(:base, 'error configuring club and leader')
      throw :abort
    end

    unless letter.save && self.letter = letter
      errors.add(:base, 'error queuing stickers for leader')
      throw :abort
    end
  end
end
