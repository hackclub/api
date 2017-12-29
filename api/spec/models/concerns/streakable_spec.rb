# frozen_string_literal: true
require 'rails_helper'

# Also see support/shared_examples/streakable.rb for shared specs to test
# Streakable models.
RSpec.describe Streakable do
  before do
    class FakeModel < OpenStruct
      @_callbacks = []

      def self.before_create(method)
        @_callbacks << { on: :create, type: :before, method: method }
      end

      def self.before_update(method)
        @_callbacks << { on: :update, type: :before, method: method }
      end

      def self.before_destroy(method)
        @_callbacks << { on: :destroy, type: :before, method: method }
      end

      include Streakable
    end
  end

  # Undeclare FakeModel
  after { Object.send(:remove_const, 'FakeModel') }

  let(:obj) { FakeModel.new }

  describe 'field mappings' do
    before do
      class FakeModel
        streak_field_mappings(
          email: '1001',
          favorite_color: {
            key: '1002',
            type: 'DROPDOWN',
            options: {
              'Green' => '9001',
              'Blue' => '9002',
              'Yellow' => '9003'
            }
          },
          attr_with_invalid_mapping: 42
        )
      end
    end

    def expect_field(instance, attribute, expected_key, expected_value)
      key, val = instance
                 .streak_field_and_value_for_attribute(attribute)
                 .values_at(:field_key, :field_value)

      expect(key).to eq(expected_key)
      expect(val).to eq(expected_value)
    end

    it 'properly parses text field mappings' do
      obj.email = 'foo@bar.com'

      expect_field(obj, :email, '1001', 'foo@bar.com')
    end

    it 'throws InvalidFieldMappingError when an invalid mapping is given' do
      expect do
        obj.streak_field_and_value_for_attribute(:attr_with_invalid_mapping)
      end.to raise_error(Streakable::InvalidFieldMappingError)
    end
  end
end
