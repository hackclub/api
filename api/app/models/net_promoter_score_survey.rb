class NetPromoterScoreSurvey < ApplicationRecord
  belongs_to :leader

  validates :score, presence: true
  validates :could_improve, presence: true
  validates :done_well, presence: true
  validates :anything_else, presence: true
end
