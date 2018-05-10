# frozen_string_literal: true

module Hackbot
  module Copy
    extend ActiveSupport::Concern

    def copy(key, hash = {}, source = default_copy_source)
      hash = hash.merge default_copy_hash

      cs = ::CopyService.new(source, hash)

      cs.get_copy key
    end

    private

    def default_copy_source
      self.class.name.demodulize.underscore
    end

    def default_copy_hash
      {
        team: team,
        event: event
      }
    end
  end
end
