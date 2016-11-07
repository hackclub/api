# Also see support/shared_examples/streakable.rb for shared specs to test
# Streakable models.
RSpec.describe Streakable do
  before do
    class FakeModel < OpenStruct
      @_callbacks = []

      def self.before_create(method);
        @_callbacks << { on: :create, type: :before, method: method }
      end

      def self.before_update(method);
        @_callbacks << { on: :update, type: :before, method: method }
      end

      def self.before_destroy(method);
        @_callbacks << { on: :destroy, type: :before, method: method }
      end

      include Streakable
    end
  end

  # Undeclare FakeModel
  after { Object.send(:remove_const, 'FakeModel') }

  let(:obj) { FakeModel.new }

  describe "field mappings" do
    before do
      class FakeModel
        streak_field_mappings(
          {
            email: "1001",
            favorite_color: {
              key: "1002",
              type: "DROPDOWN",
              options: {
                "Green" => "9001",
                "Blue" => "9002",
                "Yellow" => "9003"
              }
            },
            attribute_with_invalid_mapping: 42,
            attribute_with_invalid_mapping_type: {
              key: "1003",
              type: "FAKE_TYPE"
            }
          }
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

    it "properly parses text field mappings" do
      obj.email = "foo@bar.com"

      expect_field(obj, :email, "1001", "foo@bar.com")
    end

    it "properly parses dropdown mappings" do
      obj.favorite_color = "Blue"

      expect_field(obj, :favorite_color, "1002", "9002")
    end

    it "throws InvalidFieldMappingError when an invalid mapping is given" do
      expect {
        obj.streak_field_and_value_for_attribute(:attribute_with_invalid_mapping)
      }.to raise_error(Streakable::InvalidFieldMappingError)
    end

    it "throws InvalidFieldMappingError when an invalid mapping type is given" do
      expect {
        obj.streak_field_and_value_for_attribute(:attribute_with_invalid_mapping_type)
      }.to raise_error(Streakable::InvalidFieldMappingError)
    end
  end
end
