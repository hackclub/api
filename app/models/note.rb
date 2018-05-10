# frozen_string_literal: true

class Note < ApplicationRecord
  include Recoverable

  belongs_to :noteable, polymorphic: true
  belongs_to :user

  validates :user, :body, presence: true
end
