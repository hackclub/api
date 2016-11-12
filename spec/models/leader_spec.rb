require "rails_helper"

RSpec.describe Leader, type: :model do
  subject { build(:leader) }

  it_behaves_like "Streakable"

  it { should have_db_column :name }
  it { should have_db_column :streak_key }
  it { should have_db_column :gender }
  it { should have_db_column :year }
  it { should have_db_column :email }
  it { should have_db_column :slack_username }
  it { should have_db_column :github_username }
  it { should have_db_column :twitter_username }
  it { should have_db_column :phone_number }
  it { should have_db_column :address }
  it { should have_db_column :latitude }
  it { should have_db_column :longitude }
  it { should have_db_column :notes }

  it { should validate_presence_of :name }

  it { should have_and_belong_to_many :clubs }

  context "creation" do
    subject(:leader) { create(:leader_with_address) }

    it "geocodes the address" do
      expect(leader.latitude).to be_a BigDecimal
      expect(leader.longitude).to be_a BigDecimal
    end
  end

  context "updating" do
    describe "geocoding" do
      subject!(:leader) { create(:leader_with_address) }

      before do
        Geocoder::Lookup::Test.set_default_stub(
          [
            {
              "latitude" => 42.42,
              "longitude" => -42.42
            }
          ]
        )

        leader.address = "NEW ADDRESS"
      end

      after { Geocoder::Lookup::Test.reset }

      it "saves the new latitude" do
        expect { leader.save }.to change{leader.reload.latitude}
      end

      it "saves the new longitude" do
        expect { leader.save }.to change{leader.reload.longitude}
      end
    end
  end
end
