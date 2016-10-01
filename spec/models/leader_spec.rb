require 'rails_helper'

RSpec.describe Leader, type: :model do
  subject { build(:leader) }

  it { should have_db_column :name }
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

  it { should validate_presence_of :name }

  it "should geocode the address" do
    attrs = attributes_for(:leader_with_address).except(
      :latitude,
      :longitude
    )
    leader = Leader.create(attrs)

    expect(leader.latitude).to be_a BigDecimal
    expect(leader.longitude).to be_a BigDecimal
  end
end
