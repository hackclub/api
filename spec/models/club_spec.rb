require 'rails_helper'

RSpec.describe Club, type: :model do
  subject(:club) { build(:club) }

  it { should have_db_column :name }
  it { should have_db_column :streak_key }
  it { should have_db_column :address }
  it { should have_db_column :latitude }
  it { should have_db_column :longitude }
  it { should have_db_column :source }
  it { should have_db_column :notes }

  # Note: latitude and longitude aren't included here because they're
  # automatically set when geocoding, which breaks shoulda's test for
  # validates_presence_of.
  #
  # Try adding tests to validate_presence_of the latitude and longitude to see
  # what I mean.
  it { should validate_presence_of :name }
  it { should validate_presence_of :address }

  it { should have_and_belong_to_many :leaders }

  context 'creation' do
    let(:attrs) { attributes_for(:club).except(:streak_key, :latitude, :longitude) }
    subject(:club) { Club.create(attrs) }

    it 'geocodes the address' do
      expect(club.latitude).to be_a BigDecimal
      expect(club.longitude).to be_a BigDecimal
    end

    it "creates a new box on Streak with all attributes" do
      c = Club.new(attrs)
      c.leaders << build(:leader)
      c.leaders << build(:leader)

      client = class_double(StreakClient::Box).as_stubbed_const
      key_to_return = HCFaker::Streak.key
      field_maps = Club::STREAK_FIELD_MAPPINGS

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
                            linkedBoxKeys: c.leaders.map(&:streak_key)
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

    it 'sets streak_key' do
      expect(club.streak_key).to be_a String
    end
  end
end
