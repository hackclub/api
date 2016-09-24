require 'rails_helper'

RSpec.describe Club, type: :model do
  subject { build(:club) }

  it { should have_db_column :name }
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

  it 'should geocode the address' do
    attrs = attributes_for(:club).except(:latitude, :longitude)
    club = Club.create(attrs)

    expect(club.latitude).to be_a Float
    expect(club.longitude).to be_a Float
  end
end
