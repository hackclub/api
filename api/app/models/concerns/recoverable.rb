# frozen_string_literal: true

module Recoverable
  extend ActiveSupport::Concern

  included do
    unless column_names.include? 'deleted_at'
      return raise 'deleted_at must exist to include Recoverable'
    end

    acts_as_paranoid
  end
end
