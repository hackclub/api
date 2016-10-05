require 'rails_helper'

RSpec.describe Leader, type: :model do
  subject { build(:leader) }

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
    subject(:leader) do
      attrs = attributes_for(:leader_with_address).except(
        :streak_key,
        :latitude,
        :longitude
      )
      Leader.create(attrs)
    end

    it "geocodes the address" do
      expect(leader.latitude).to be_a BigDecimal
      expect(leader.longitude).to be_a BigDecimal
    end

    it "sets streak_key" do
      expect(leader.streak_key).to be_a String
    end
  end
end
