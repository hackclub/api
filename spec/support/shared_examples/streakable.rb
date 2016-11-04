require "rails_helper"

RSpec.shared_examples "Streakable" do
  let(:model) { described_class }
  let!(:attrs) { attributes_from_created_instance(model).except(:streak_key) }

  context "creation" do
    it "creates a new box on Streak with all mapped fields" do
      instance = model.new(attrs)

      client = class_double(StreakClient::Box).as_stubbed_const
      streak_key = HCFaker::Streak.key
      field_maps = model.field_mappings

      expect(client).to receive(:create_in_pipeline)
                          .with(
                            model.pipeline_key,
                            attrs[model.name_attribute]
                          )
                          .and_return({ key: streak_key })

      expect_update_box(
        streak_client_double: client,
        streak_key: streak_key,
        notes: attrs[model.notes_attribute],
        linked_box_keys: [] # TODO: Don't do this
      )

      expect_update_box_fields(
        streak_client_double: client,
        streak_key: streak_key,
        field_mappings: field_maps,
        attrs: attrs
      )

      instance.save
    end

    it "sets the mapped Streak key attribute to the new box's key" do
      instance = model.new(attrs)
      streak_key = HCFaker::Streak.key

      expect(StreakClient::Box).to receive(:create_in_pipeline)
                                     .and_return(key: streak_key)

      expect {
        instance.save
      }.to change{
        instance.send(model.key_attribute)
      }.from(nil).to(streak_key)
    end
  end

  context "updating" do
    let!(:new_attrs) { attributes_from_created_instance(model).except(:streak_key) }
    subject!(:instance) { model.create(attrs) }

    it "updates the Streak box's fields" do
      client = class_double(StreakClient::Box).as_stubbed_const

      expect_update_box(
        streak_client_double: client,
        streak_key: instance.streak_key,
        notes: new_attrs[model.notes_attribute],
        linked_box_keys: [] # TODO: Don't do this
      )

      expect_update_box_fields(
        streak_client_double: client,
        streak_key: instance.streak_key,
        field_mappings: model.field_mappings,
        attrs: new_attrs
      )

      instance.update_attributes(new_attrs)
    end
  end

  context "deletion" do
    subject!(:instance) { factory_instance(model) }

    it "deletes the corresponding box on Streak" do
      client = class_double(StreakClient::Box).as_stubbed_const

      expect(client).to receive(:delete)
                          .with(
                            instance.streak_key
                          )

      instance.destroy!
    end
  end

  def factory_instance(model_class)
    create(model_class.to_s.underscore.to_sym)
  end

  def attributes_from_created_instance(model_class)
    instance = factory_instance(model_class)
    attrs = instance
              .attributes
              .with_indifferent_access
              .except(:id, :created_at, :updated_at)
    instance.destroy!

    attrs
  end

  def expect_update_box(streak_client_double:, streak_key:, notes:, linked_box_keys:)
    expect(streak_client_double).to receive(:update)
                                      .with(
                                        streak_key,
                                        notes: notes,
                                        linkedBoxKeys: linked_box_keys
                                      )
  end

  def expect_update_box_fields(streak_client_double:, streak_key:, field_mappings:, attrs:)
    field_mappings.each do |attribute_name, mapping|
      field_key = nil
      field_value = nil

      case mapping
      when Hash
        field_key = mapping[:key]

        case mapping[:type]
        when "DROPDOWN"
          field_value = mapping[:options][attrs[attribute_name]]
        else
          raise "Unknown Streak field mapping type given"
        end
      when String
        field_key = mapping
        field_value = attrs[attribute_name]
      else
        raise "Invalid Streak field mapping type given"
      end

      expect(streak_client_double).to receive(:edit_field)
                                        .with(
                                          streak_key,
                                          field_key,
                                          field_value
                                        )
    end
  end
end
