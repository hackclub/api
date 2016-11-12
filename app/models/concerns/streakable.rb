# frozen_string_literal: true
module Streakable
  extend ActiveSupport::Concern

  class InvalidFieldMappingError < StandardError; end

  module ClassMethods
    attr_reader :pipeline_key, :field_mappings,
                :key_attribute, :name_attribute, :notes_attribute

    # Returns an array of AssociationReflection objects. Each
    # AssociationReflection represents an association with a class that also
    # includes Streakable.
    def streakable_associations
      self.reflect_on_all_associations.select do |association|
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

    def streak_default_field_mappings(key:, name:, notes:)
      @key_attribute = key
      @name_attribute = name
      @notes_attribute = notes
    end
  end

  included do
    before_create :create_box
    before_update :update_box_if_changed
    before_destroy :destroy_box
  end

  def update_attributes_without_streak(attrs)
    self.class.skip_callback(:update, :before, :update_box_if_changed)
    update_attributes(attrs)
    self.class.set_callback(:update, :before, :update_box_if_changed)
  end

  def destroy_without_streak!
    self.class.skip_callback(:destroy, :before, :destroy_box)
    destroy!
    self.class.set_callback(:destroy, :before, :destroy_box)
  end

  # Given a symbol attribute name, get that attribute's value, parse the model's
  # field mappings, and return the field key and value that's appropriate for
  # sending to Streak.
  def streak_field_and_value_for_attribute(attribute)
    mapping = self.class.field_mappings[attribute]
    stored_value = send(attribute)

    case mapping
    when Hash
      field_key = mapping[:key]
    when String
      field_key = mapping
    else
      raise InvalidFieldMappingError, "Invalid Streak field mapping given"
    end

    { field_key: field_key, field_value: stored_value }
  end

  # Returns an array of box keys suitable for passing to Streak's API
  def linked_streak_box_keys
    association_names = self.class.streakable_associations.map(&:plural_name)

    association_names.inject([]) do |keys, name|
      associated_objs = send(name)
      keys + associated_objs.map { |obj| obj.send(obj.class.key_attribute) }
    end
  end

  def create_box
    unless get_streak_key
      resp = StreakClient::Box.create_in_pipeline(self.class.pipeline_key, name)
      set_streak_key(resp[:key])

      update_streak_box
    end
  end

  def update_box
    update_streak_box
  end

  def destroy_box
    StreakClient::Box.delete(get_streak_key)
  end

  private

  def update_box_if_changed
    update_box if self.changed?
  end

  # Helpers
  def update_streak_box
    StreakClient::Box.update(
      get_streak_key,
      notes: notes,
      linkedBoxKeys: linked_streak_box_keys
    )

    update_all_streak_fields
  end

  def update_all_streak_fields
    self.class.field_mappings.keys.each do |attribute|
      for_streak = streak_field_and_value_for_attribute(attribute)

      StreakClient::Box.edit_field(
        get_streak_key,
        for_streak[:field_key],
        for_streak[:field_value]
      )
    end
  end

  def get_streak_key
    send(self.class.key_attribute)
  end

  def set_streak_key(val)
    send("#{self.class.key_attribute}=", val)
  end
end
