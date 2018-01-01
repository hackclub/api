# frozen_string_literal: true

# This module provides additional fake data generators (in addition to Faker)
module HCFaker
  class HighSchool
    class << self
      def name
        "#{Faker::Address.city} High School"
      end
    end
  end

  class Address
    class << self
      def full_address
        "#{Faker::Address.street_address}, #{Faker::Address.city}, "\
        "#{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
      end
    end
  end

  class Random
    class << self
      def alphanumeric_string(len: 42)
        range = [*'0'..'9', *'A'..'Z', *'a'..'z']
        Array.new(len) { range.sample }.join
      end

      def numeric_string(len: 4)
        chars = [*'0'...'9']
        Array.new(len) { chars.sample }.join
      end
    end
  end

  class Streak
    class << self
      def key
        HCFaker::Random.alphanumeric_string(len: 91)
      end

      def stage_key
        HCFaker::Random.numeric_string(len: 4)
      end

      def stage_key_alive
        %w[5003 5014].sample
      end

      def stage_key_dead
        '5004'
      end
    end
  end
end
