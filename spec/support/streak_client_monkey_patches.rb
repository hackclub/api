# frozen_string_literal: true

# This file monkey patches StreakClient to make testing it easier.
module StreakClient
  module Pipeline
  end

  module Box
    # Have create_in_pipeline return an object with a randomly generated
    # :streak_key and the name that was passed.
    def self.create_in_pipeline(_pipeline_key, name)
      # Random 91 character alphanumeric string
      range = [*'0'..'9', *'A'..'Z', *'a'..'z']
      streak_key = Array.new(91) { range.sample }.join

      {
        key: streak_key,
        name: name
      }
    end

    # TODO: Return the full "updated" box here
    def self.update(_box_key, _params); end

    def self.edit_field(_box_key, field_key, value)
      {
        key: field_key,
        value: value
      }
    end

    def self.delete(_box_key)
      {
        success: true
      }
    end
  end
end
