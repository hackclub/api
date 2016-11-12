require "rails_helper"

RSpec.describe Club, type: :model do
  subject(:club) { build(:club) }

  it_behaves_like "Streakable"

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
    subject(:club) { create(:club) }

    it "geocodes the address" do
      expect(club.latitude).to be_a BigDecimal
      expect(club.longitude).to be_a BigDecimal
    end
  end

  context "updating" do
    describe "geocoding" do
      subject!(:club) { create(:club) }

      before do
        Geocoder::Lookup::Test.set_default_stub(
          [
            {
              'latitude' => 42.42,
              'longitude' => -42.42
            }
          ]
        )

        club.address = "NEW ADDRESS"
      end

      after { Geocoder::Lookup::Test.reset }

      it "saves the new latitude" do
        expect { club.save }.to change{club.reload.latitude}
      end

      it "saves the new longitude" do
        expect { club.save }.to change{club.reload.longitude}
      end
    end
  end
end
