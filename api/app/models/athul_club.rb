# frozen_string_literal: true

class AthulClub < ApplicationRecord
  belongs_to :club, dependent: :destroy
  belongs_to :leader, dependent: :destroy
  belongs_to :letter, dependent: :destroy

  accepts_nested_attributes_for :club, :leader

  validates :club, uniqueness: true

  before_create :init
  def init
    club.stage_key = '5020' # Indian club stage
    leader.stage_key = '5008' # Indian leader stage

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

    error_msg = 'error configuring club and leader'
    abort_with_error(error_msg) unless club.save && leader.save

    error_msg = 'error matching email to Slack user'
    abort_with_error(error_msg) unless leader.resolve_email_to_slack_id

    error_msg = 'error queuing stickers for leader'
    abort_with_error(error_msg) unless letter.save && (self.letter = letter)
  end

  private

  def abort_with_error(msg)
    club.try :destroy
    leader.try :destroy
    letter.try :destroy

    errors.add(:base, msg)

    throw :abort
  end
end
