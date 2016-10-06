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
    let(:attrs) { attributes_for(:leader_with_address).except(:streak_key, :latitude, :longitude) }
    subject(:leader) { Leader.create(attrs) }

    it "geocodes the address" do
      expect(leader.latitude).to be_a BigDecimal
      expect(leader.longitude).to be_a BigDecimal
    end

    it "creates a new box on Streak with all attributes" do
      l = Leader.new(attrs)
      l.clubs << build(:club)

      client = class_double(StreakClient::Box).as_stubbed_const
      streak_key = HCFaker::Streak.key
      field_maps = Leader::STREAK_FIELD_MAPPINGS

      expect(client).to receive(:create_in_pipeline)
                          .with(
                            Rails.application.secrets.streak_leader_pipeline_key,
                            attrs[:name]
                          )
                          .and_return({ key: streak_key })
      expect(client).to receive(:update)
                          .with(
                            streak_key,
                            notes: attrs[:notes],
                            linkedBoxKeys: l.clubs.map(&:streak_key)
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:email],
                            attrs[:email]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:gender][:key],
                            field_maps[:gender][:options][attrs[:gender]]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:year][:key],
                            field_maps[:year][:options][attrs[:year]]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:phone_number],
                            attrs[:phone_number]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:slack_username],
                            attrs[:slack_username]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:github_username],
                            attrs[:github_username]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:twitter_username],
                            attrs[:twitter_username]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:address],
                            attrs[:address]
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:latitude],
                            anything
                          )
      expect(client).to receive(:edit_field)
                          .with(
                            streak_key,
                            field_maps[:longitude],
                            anything
                          )

      l.save
    end

    it "sets streak_key" do
      expect(leader.streak_key).to be_a String
    end
  end
end
