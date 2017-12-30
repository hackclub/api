# frozen_string_literal: true
class NetPromoterScoreSurvey < ApplicationRecord
  belongs_to :leader

  validates :score, :could_improve, :done_well, :anything_else, presence: true
end
