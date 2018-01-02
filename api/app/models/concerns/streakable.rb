# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Streakable
  extend ActiveSupport::Concern

  class InvalidFieldMappingError < StandardError; end

  STAGE_KEY_COLUMN_NAME = 'stage_key'

  module ClassMethods
    attr_reader :pipeline_key, :field_mappings, :key_attribute,
                :name_attribute, :notes_attribute, :stage_attribute

    # Returns an array of AssociationReflection objects. Each
    # AssociationReflection represents an association with a class that also
    # includes Streakable.
    def streakable_associations
      reflect_on_all_associations.select do |association|
        association.klass.included_modules.include? Streakable
      end
    end

    private

    def streak_pipeline_key(key)
      @pipeline_key = key
    end

    def streak_field_mappings(mappings)
      @field_mappings = mappings
    end

    def streak_default_field_mappings(key:, name:, notes:, stage:)
      @key_attribute = key
      @name_attribute = name
      @notes_attribute = notes
      @stage_attribute = stage
    end

    def streak_read_only(mapping)
      @field_mappings ||= {}
      @field_mappings = @field_mappings.merge(mapping)

      mapping.each_key do |sym|
        # Construct a setter out of the symbol
        read_only = :"#{sym.to_s + '='}"

        define_method(read_only) { |_| nil }
      end
    end
  end

  included do
    before_create :create_box
    before_update :update_box_if_changed
    before_destroy :destroy_box
  end

  def destroy_without_streak!
    self.class.skip_callback(:destroy, :before, :destroy_box)
    destroy!
    self.class.set_callback(:destroy, :before, :destroy_box)
  end

  def streak_field_key_for_attribute(attribute)
    mapping = self.class.field_mappings[attribute]

    case mapping
    when Hash
      mapping[:key]
    when String
      mapping
    else
      raise InvalidFieldMappingError, 'Invalid Streak field mapping given'
    end
  end

  def streak_field_value_for_attribute(attribute)
    val = send(attribute)
    mapping = self.class.field_mappings[attribute]

    return val unless mapping.is_a? Hash

    if mapping[:type] == 'DATE'
      time_to_ms_since_epoch(val)
    else
      val
    end
  end

  # Given a symbol attribute name, get that attribute's value, parse the model's
  # field mappings, and return the field key and value that's appropriate for
  # sending to Streak.
  def streak_field_and_value_for_attribute(attribute)
    {
      field_key: streak_field_key_for_attribute(attribute),
      field_value: streak_field_value_for_attribute(attribute)
    }
  end

  # Returns an array of box keys suitable for passing to Streak's API
  def linked_streak_box_keys
    association_names = self.class.streakable_associations.map(&:plural_name)

    association_names.inject([]) do |keys, name|
      if send(:respond_to?, name)
        associated_objs = send(name)
        keys + associated_objs.map { |obj| obj.send(obj.class.key_attribute) }
      else
        keys
      end
    end
  end

  def create_box
    unless streak_key_val
      resp = StreakClient::Box.create_in_pipeline(self.class.pipeline_key,
                                                  name_key_val)

      # Need to use self here because it'll try to create a variable by default
      # (try removing 'self.' from the beginning and running tests to see for
      # yourself)
      self.streak_key_val = resp[:key]
    end

    update_streak_box
  end

  def update_box
    update_streak_box
  end

  def destroy_box
    StreakClient::Box.delete(streak_key_val)
  end

  private

  def update_box_if_changed
    update_box if changed?
  end

  # Helpers
  def update_streak_box
    StreakClient::Box.update(
      streak_key_val,
      notes: notes,
      linked_box_keys: linked_streak_box_keys,
      stage_key: stage_key_val
    )

    update_all_streak_fields
  end

  def update_all_streak_fields
    self.class.field_mappings.each_key do |attribute|
      for_streak = streak_field_and_value_for_attribute(attribute)

      StreakClient::Box.edit_field(
        streak_key_val,
        for_streak[:field_key],
        for_streak[:field_value]
      )
    end
  end

  def streak_key_val
    send(self.class.key_attribute)
  end

  def streak_key_val=(val)
    send("#{self.class.key_attribute}=", val)
  end

  def stage_key_val
    send(self.class.stage_attribute)
  end

  def stage_key_val=(val)
    send("#{self.class.stage_attribute}=", val)
  end

  def name_key_val
    send(self.class.name_attribute)
  end

  def name_key_val=(val)
    send("#{self.class.name_attribute}=", val)
  end

  def time_to_ms_since_epoch(time)
    (time.to_f * 1000).to_i
  end
end
# rubocop:enable Metrics/ModuleLength
