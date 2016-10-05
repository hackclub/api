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
    subject(:club) do
      attrs = attributes_for(:club).except(:streak_key, :latitude, :longitude)
      Club.create(attrs)
    end

    it 'geocodes the address' do
      expect(club.latitude).to be_a BigDecimal
      expect(club.longitude).to be_a BigDecimal
    end

    it "creates a new box on Streak" do
      client = class_double(StreakClient::Box)

      expect(client).to receive(:create_in_pipeline)

      StreakClient::Box.create_in_pipeline("asdf", "adsf")
    end

    it 'sets streak_key' do
      expect(club.streak_key).to be_a String
    end
  end
end
