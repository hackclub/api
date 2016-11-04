require "rails_helper"

RSpec.describe Club, type: :model do
  subject(:club) { build(:club) }

  it { should have_db_column :name }
  it { should have_db_column :streak_key }
  it { should have_db_column :address }
  it { should have_db_column :latitude }
  it { should have_db_column :longitude }
  it { should have_db_column :source }
  it { should have_db_column :notes }

  # Note: latitude and longitude aren"t included here because they"re
  # automatically set when geocoding, which breaks shoulda's test for
  # validates_presence_of.
  #
  # Try adding tests to validate_presence_of the latitude and longitude to see
  # what I mean.
  it { should validate_presence_of :name }
  it { should validate_presence_of :address }

  it { should have_and_belong_to_many :leaders }

  context "creation" do
    let(:attrs) { attributes_for(:club).except(:streak_key, :latitude, :longitude) }
    subject(:club) { Club.create(attrs) }

    it "geocodes the address" do
      expect(club.latitude).to be_a BigDecimal
      expect(club.longitude).to be_a BigDecimal
    end

    context "without leaders" do
      it "creates a new box on Streak with all attributes" do
        c = Club.new(attrs)

        client = class_double(StreakClient::Box).as_stubbed_const
        key_to_return = HCFaker::Streak.key
        field_maps = Club.field_mappings

        expect(client).to receive(:create_in_pipeline)
                            .with(
                              Rails.application.secrets.streak_club_pipeline_key,
                              attrs[:name]
                            )
                            .and_return({ key: key_to_return })
        expect(client).to receive(:update)
                            .with(
                              key_to_return,
                              notes: attrs[:notes],
                              linkedBoxKeys: []
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              key_to_return,
                              field_maps[:address],
                              attrs[:address]
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              key_to_return,
                              field_maps[:latitude],
                              anything
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              key_to_return,
                              field_maps[:longitude],
                              anything
                            )
        expect(client).to receive(:edit_field)
                            .with(
                              key_to_return,
                              field_maps[:source][:key],
                              field_maps[:source][:options][attrs[:source]]
                            )

        c.save
      end
    end

    it "sets streak_key" do
      expect(club.streak_key).to be_a String
    end
  end

  context "updating" do
    let(:attrs) { attributes_for(:club).except(:streak_key, :latitude, :longitude) }
    subject(:club) { Club.create(attrs) }

    before do
      club.update_attributes(source: "Press")

      club.name = "NEW NAME"
      club.address = "NEW ADDRESS"
      club.source = "Word of Mouth"
      club.notes = "NEW NOTES"
    end

    describe "geocoding" do
      before do
        Geocoder::Lookup::Test.set_default_stub(
          [
            {
              'latitude' => 42.42,
              'longitude' => -42.42
            }
          ]
        )
      end

      after { Geocoder::Lookup::Test.reset }

      it "saves the new latitude" do
        expect { club.save }.to change{club.reload.latitude}
      end

      it "saves the new longitude" do
        expect { club.save }.to change{club.reload.longitude}
      end
    end

    # TODO: This should also check for the case where the club has leaders. Not
    # sure the best way to implement a test for this.
    it "updates the Streak box's attributes" do
      client = class_double(StreakClient::Box).as_stubbed_const
      field_maps = Club.field_mappings

      expect(client).to receive(:update)
                         .with(
                           club.streak_key,
                           notes: "NEW NOTES",
                           linkedBoxKeys: club.leaders.map(&:streak_key)
                         )
      expect(client).to receive(:edit_field)
                         .with(
                           club.streak_key,
                           field_maps[:address],
                           "NEW ADDRESS"
                         )
      expect(client).to receive(:edit_field)
                         .with(
                           club.streak_key,
                           field_maps[:latitude],
                           anything
                         )
      expect(client).to receive(:edit_field)
                         .with(
                           club.streak_key,
                           field_maps[:longitude],
                           anything
                         )
      expect(client).to receive(:edit_field)
                         .with(
                           club.streak_key,
                           field_maps[:source][:key],
                           field_maps[:source][:options]["Word of Mouth"]
                         )

      club.save
    end
  end

  context "deletion" do
    subject(:club) { create(:club) }

    it "deletes the club on Streak" do
      client = class_double(StreakClient::Box).as_stubbed_const

      expect(client).to receive(:delete)
                         .with(
                           club.streak_key
                         )

      club.destroy!
    end
  end
end
