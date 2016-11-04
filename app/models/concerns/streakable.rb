module Streakable
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :pipeline_key, :field_mappings,
                :key_attribute, :name_attribute, :notes_attribute

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
    before_update :update_box
    before_destroy :destroy_box
  end

  def destroy_without_streak!
    self.class.skip_callback(:destroy, :before, :destroy_box)
    destroy!
    self.class.set_callback(:destroy, :before, :destroy_box)
  end

  private

  def create_box
    unless get_streak_key
      resp = StreakClient::Box.create_in_pipeline(self.class.pipeline_key, self.name)
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

  # Helpers

  def linked_streak_box_keys
    association_names = streakable_associations.map(&:plural_name)

    association_names.inject([]) do |keys, name|
      associated_objs = send(name)
      keys + associated_objs.map { |obj| obj.class.key_attribute }
    end
  end

  def update_streak_box
    StreakClient::Box.update(
      get_streak_key,
      notes: self.notes,
      linkedBoxKeys: linked_streak_box_keys
    )

    update_all_streak_fields
  end

  def update_all_streak_fields
    self.class.field_mappings.each do |field_name, mapping|
      update_streak_field(field_name, mapping)
    end
  end

  def update_streak_field(field_name, mapping)
    field_key = nil
    field_value = nil

    case mapping
    when Hash
      field_key = mapping[:key]

      case mapping[:type]
      when "DROPDOWN"
        field_value = mapping[:options][send(field_name)]
      else
        raise "Unknown Streak field mapping type given"
      end
    when String
      field_key = mapping
      field_value = send(field_name)
    else
      raise "Invalid Streak field mapping type given"
    end

    StreakClient::Box.edit_field(
      get_streak_key,
      field_key,
      field_value
    )
  end

  def streakable_associations
    self.class.reflect_on_all_associations.select do |association|
      association.klass.included_modules.include? Streakable
    end
  end

  def get_streak_key
    send(self.class.key_attribute)
  end

  def set_streak_key(val)
    send("#{self.class.key_attribute}=", val)
  end
end
