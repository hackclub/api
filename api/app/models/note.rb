# frozen_string_literal: true

class Note < ApplicationRecord
  acts_as_paranoid

  belongs_to :noteable, polymorphic: true
  belongs_to :user

  validates :user, :body, presence: true
end
